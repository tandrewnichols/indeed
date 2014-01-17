var _ = require('underscore');

_.mixin({
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
  test: function() {
    var last = this.current.pop(), val;
    if (this.current.length) {
      val = !!(_[last.join](this._compare(this.current, this.current.shift()), last.val) ^ this.groupNegate);
    } else {
      val = !!(last.val ^ last.negate ^ this.groupNegate);
    }
    if (this.previous.length) {
      return _[_(this.previous).last().join](this._compare(this.previous, this.previous.shift()), val);
    } else {
      return val; 
    }
  },

  _compare: function(list, item) {
    if (list.length) {
      return !!(_[item.join](this._compare(list, list.shift()), item.val) ^ item.negate);
    } else {
      return item.val;
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
    return this._chain('allOf', condition);
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
    this.previous.push({ val: this.test(), join: 'and' });
    this.calls = [];
    return this;
  },
  
  get But() {
    this.previous.push({ val: this.test(), join: 'and' });
    this.calls = [];
    return this;
  },

  get Or() {
    this.previous.push({ val: this.test(), join: 'or' });
    this.calls = [];
    return this;
  },

  get Xor() {
    this.previous.push({ val: this.test(), join: 'xor' });
    this.calls = [];
    return this;
  },

  get Not() {
    this.groupNegate = true;
    return this;
  },

  is: function(condition) { 
    var current = this.current.pop();
    if (!current.compared) {
      current = {
        val: this.current.actual === condition,
        actual: this.current.actual,
        compared: 'is'
      };
    } else {
      throw new Error('IllegalMethodException: is cannot be called with ' + current.compared);
    }
    this.current.push(current);
    return this;
  },

  equals: function(condition) {
    var current = this.current.pop();
    if (!current.compared) {
      current = {
        val: current.actual === condition,
        actual: current.actual,
        compared: 'equals'
      };
    } else {
      throw new Error('IllegalMethodException: equals cannot be called with ' + current.compared);
    }
    this.current.push(current);
    return this;
  }
};

Indeed.prototype.eval = Indeed.prototype.val = Indeed.prototype.test;

module.exports = indeed;
