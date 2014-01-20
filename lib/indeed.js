var _ = require('underscore');

_.mixin({
  capitalize: function(thing) {
    return thing.charAt(0).toUpperCase() + thing.slice(1);
  },
  and: function(a, b) {
    return a && b;
  },
  or: function(a, b) {
    return a || b;
  },
  xor: function(a, b) {
    return ((a || b) && !(a && b));
  }
});

var allowed = {
  indeed: {
    list: ['and', 'andNot', 'or', 'orNot', 'butNot', 'xor'],
    chain: true
  },
  also: {
    list: ['and', 'andNot', 'or', 'orNot', 'butNot', 'xor'],
    chain: true
  },
  else: {
    list: ['and', 'andNot', 'or', 'orNot', 'butNot', 'xor'],
    chain: true
  },
  not: {
    list: ['and', 'andNot', 'or', 'orNot', 'butNot', 'xor'],
    chain: true
  },
  either: {
    list: ['or'],
    chain: false
  },
  neither: {
    list: ['nor'],
    chain: false
  },
  both: {
    list: ['and'],
    chain: false
  },
  allOf: {
    list: ['and'],
    chain: true
  },
  oneOf: {
    list: ['and'],
    chain: true
  },
  anyOf: {
    list: ['and'],
    chain: true
  },
  noneOf: {
    list: ['and'],
    chain: true
  }
};

var indeed = function(condition) {
  return new Indeed(condition);
};

indeed.not = function(condition) {
  return new Indeed(condition, true);
};

indeed.Not = function(condition) {
  var i = new Indeed(condition);
  i.groupNegate = true;
  return i;
};

indeed.mixin = function(obj) {
  _.chain(obj).keys().each(function(key) {
    var fn = function(condition) {
      return this._compare(key, obj[key](condition));
    };
    Indeed.prototype[key] = fn;
  });
};

var Indeed = indeed.Indeed = function Indeed (condition, negate) {
  this.previous = [];
  this.current = [{
    val: condition,
    negate: negate,
    actual: condition
  }];
  this.calls = ['indeed'];
};

Indeed.prototype = {
  test: function(currentOnly) {
    var last = this.current.pop(), val;
    if (this.current.length) {
      val = !!(_[last.join](this._getCurrent(this.current, this.current.pop()), (last.val ^ last.negate)) ^ this.groupNegate);
    } else {
      val = !!((last.val ^ last.negate) ^ this.groupNegate);
    }
    if (this.previous.length && !currentOnly) {
      var method = _(this.previous).last().join;
      var result = this._getPrevious(this.previous, this.previous.pop());
      return _[method](result, val);
    } else {
      return val; 
    }
  },

  _getPrevious: function(list, item) {
    if (list.length) {
      var method = _(list).last().join;
      var result = this._getPrevious(list, list.pop());
      return !!(_[method](result, item.val) ^ item.negate);
    } else {
      return !!(item.val ^ item.negate);
    }
  },

  _getCurrent: function(list, item) {
    if (list.length) {
      var result = this._getCurrent(list, list.pop());
      return !!(_[item.join](result, item.val) ^ item.negate);
    } else {
      return !!(item.val ^ item.negate);
    }
  },

  _chain: function(name, condition, join, negate) {
    var calls = this.calls;
    var allow = allowed[(calls[0] || name)];
    var ok = _.chain([calls, name]).flatten().all(function(c) {
      return _.chain([allow.list, (calls[0] || name)]).flatten().contains(c).value();
    }).value();
    if (!ok || (allow.list.length === 1 && calls.length === 2 && !allow.chain) || (calls.length === 1 && calls[0] === name)) {
      var display = (allow.list.length === 1 && calls.length === 2 && !allow.chain) ? calls[0] + '/' + calls[1] : calls[0];
      throw new Error('IllegalMethodException: ' + name + ' cannot be called with ' + display);
    } else {
      var obj = {
        val: condition,
        actual: condition
      };
      if (typeof join === 'string') {
        obj.join = join;
        obj.negate = negate;
      }
      if (typeof join === 'boolean') {
        obj.negate = join;
      }
      this.current.push(obj);
      this.calls.push(name);
      return this;
    }
  },

  and: function(condition) {
    return this._chain('and', condition, 'and');
  },
  
  andNot: function(condition) {
    return this._chain('andNot', condition, 'and', true);
  },

  butNot: function(condition) {
    return this._chain('butNot', condition, 'and', true);
  },

  or: function(condition) {
    return this._chain('or', condition, 'or');
  },

  orNot: function(condition) {
    return this._chain('orNot', condition, 'or', true);
  },

  xor: function(condition) {
    return this._chain('xor', condition, 'xor');
  },

  indeed: function(condition) {
    return this._chain('indeed', condition);
  },

  either: function(condition) {
    return this._chain('either', condition);
  },

  neither: function(condition) {
    return this._chain('neither', condition, true);
  },

  nor: function(condition) {
    return this._chain('nor', condition, 'and', true);
  },

  also: function(condition) {
    return this._chain('also', condition, 'and');
  },

  else: function(condition) {
    return this._chain('else', condition);
  },

  not: function(condition) {
    return this._chain('not', condition, true);
  },

  both: function(condition) {
    return this._chain('both', condition);
  },

  allOf: function(condition) {
    return this._rewrite('allOf', condition, function(conditions) {
      return _(conditions).all();
    });
  },

  oneOf: function(condition) {
    return this._rewrite('oneOf', condition, function(conditions) {
      return _(conditions).countBy(function(cond) {
        return !!cond ? 'true' : 'false';
      }).true === 1;
    });
  },

  anyOf: function(condition) {
    return this._rewrite('anyOf', condition, function(conditions) {
      return _(conditions).any();
    });
  },

  noneOf: function(condition) {
    return this._rewrite('noneOf', condition, function(conditions) {
      return _(conditions).all(function(c) {
        return !c;
      });
    });
  },

  _rewrite: function(method, condition, testFunc) {
    var _and = this.and,
        _test = this.test,
        conditions = [condition];
    this.and = function(condition) {
      conditions.push(condition);
      return this;
    };
    this.test = function() {
      this.and = _and;
      this.test = _test;
      this.current = [{
        val: testFunc(conditions),
        actual: ''
      }];
      return this.test();
    };
    return this._chain(method, condition);
  },

  get And() {
    this.previous.push({ val: this.test(true), join: 'and' });
    this.calls = [];
    return this;
  },
  
  get But() {
    this.previous.push({ val: this.test(true), join: 'and' });
    this.calls = [];
    return this;
  },

  get Or() {
    this.previous.push({ val: this.test(true), join: 'or' });
    this.calls = [];
    return this;
  },

  get Xor() {
    this.previous.push({ val: this.test(true), join: 'xor' });
    this.calls = [];
    return this;
  },

  get Not() {
    this.groupNegate = true;
    return this;
  },

  _compare: function(method, tester) {
    var current = this.current.pop();
    if (!current.compare) {
      current.val = tester(current.actual);
      current.compare = method;
    } else {
      throw new Error('IllegalMethodException: ' + method + ' cannot be called with ' + current.compared);
    }
    this.current.push(current);
    return this;
  },

  is: function(condition) { 
    return this._compare('is', function(val) {
      return val === condition;
    });
  },

  equals: function(condition) {
    return this._compare('equals', function(val) {
      return _(val).isEqual(condition);
    });
  },

  isA: function(condition) {
    return this._compare('isA', function(val) {
      try {
        return val.constructor.name.toLowerCase() === condition.toLowerCase();
      } catch (e) {
        return typeof val === condition && val !== null && typeof val !== 'undefined';
      }
    });
  },

  isAn: function(condition) {
    return this._compare('isAn', function(val) {
      try {
        return val.constructor.name.toLowerCase() === condition.toLowerCase();
      } catch (e) {
        return typeof val === condition && val !== null && typeof val !== 'undefined';
      }
    });
  },

  contains: function(condition) {
    return this._compare('contains', function(val) {
      return !!~val.indexOf(condition);
    });
  },

  containsKey: function(condition) {
    return this._compare('containsKey', function(val) {
      return _.chain(val).keys().contains(condition).value();
    });
  },

  containsValue: function(condition) {
    return this._compare('containsValue', function(val) {
      return _.chain(val).values().contains(condition).value();
    });
  },

  isDefined: function() {
    return this._compare('isDefined', function(val) {
      return typeof val !== 'undefined';
    });
  },

  isNull: function() {
    return this._compare('isNull', function(val) {
      return val === null;
    });
  },

  isNotNull: function() {
    return this._compare('isNull', function(val) {
      return val !== null;
    });
  },

  isTrue: function() {
    return this._compare('isTrue', function(val) {
      return val === true;
    });
  },
  
  isFalse: function() {
    return this._compare('isFalse', function(val) {
      return val === false;
    });
  },

  isGreaterThan: function(condition) {
    return this._compare('isGreaterThan', function(val) {
      return _(val).isNumber() && val > condition;
    });
  },

  isLessThan: function(condition) {
    return this._compare('isGreaterThan', function(val) {
      return _(val).isNumber() && val < condition;
    });
  },

  isGreaterThanOrEqualTo: function(condition) {
    return this._compare('isGreaterThanOrEqualTo', function(val) {
      return _(val).isNumber() && val >= condition;
    });
  },

  isLessThanOrEqualTo: function(condition) {
    return this._compare('isGreaterThanOrEqualTo', function(val) {
      return _(val).isNumber() && val <= condition;
    });
  }
};

Indeed.prototype.eval = Indeed.prototype.val = Indeed.prototype.test;
Indeed.prototype.isGt = Indeed.prototype.isGreaterThan;
Indeed.prototype.isLt = Indeed.prototype.isLessThan;
Indeed.prototype.isGte = Indeed.prototype.isGreaterThanOrEqualTo;
Indeed.prototype.isLte = Indeed.prototype.isLessThanOrEqualTo;

module.exports = indeed;
