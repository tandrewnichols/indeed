var _ = require('underscore'),
    Base = require('./base'),
    util = require('util'),
    allowed = require('./allowed');

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

var indeed = function(condition) {
  return new Indeed(condition);
};

indeed.not = function(condition) {
  return new Indeed(condition, true);
};

indeed.Not = function(condition) {
  var i = new Indeed(condition);
  i.flags.groupNot = true;
  return i;
};

indeed.mixin = function(obj) {
  _.chain(obj).keys().each(function(key) {
    var fn = function(condition) {
      return this._compare(obj[key](condition), key);
    };
    Base.prototype[key] = fn;
  });
};

var Indeed = indeed.Indeed = function Indeed () {
  Base.apply(this, arguments);
  this.calls = ['indeed'];
  this.previous = [];
  this.__defineGetter__('And', function() {
    this.previous.push({ val: this.test(true), join: 'and' });
    this.calls = [];
    return this;
  });
  this.__defineGetter__('But', function() {
    this.previous.push({ val: this.test(true), join: 'and' });
    this.calls = [];
    return this;
  });
  this.__defineGetter__('Or', function() {
    this.previous.push({ val: this.test(true), join: 'or' });
    this.calls = [];
    return this;
  });
  this.__defineGetter__('Xor', function() {
    this.previous.push({ val: this.test(true), join: 'xor' });
    this.calls = [];
    return this;
  });
};

util.inherits(Indeed, Base);

Indeed.prototype.test = function(currentOnly) {
  var last = this.current.pop(), val;
  if (this.current.length) {
    val = !!(_[last.join](this._getCurrent(this.current, this.current.pop()), (last.val ^ last.negate)) ^ this.flags.groupNot);
  } else {
    val = !!((last.val ^ last.negate) ^ this.flags.groupNot);
  }
  if (this.previous.length && !currentOnly) {
    var method = _(this.previous).last().join;
    var result = this._getPrevious(this.previous, this.previous.pop());
    return _[method](result, val);
  } else {
    return val; 
  }
};

Indeed.prototype._getPrevious = function(list, item) {
  if (list.length) {
    var method = _(list).last().join;
    var result = this._getPrevious(list, list.pop());
    return !!(_[method](result, item.val) ^ item.negate);
  } else {
    return !!(item.val ^ item.negate);
  }
};

Indeed.prototype._getCurrent = function(list, item) {
  if (list.length) {
    var result = this._getCurrent(list, list.pop());
    return !!(_[item.join](result, item.val) ^ item.negate);
  } else {
    return !!(item.val ^ item.negate);
  }
};

Indeed.prototype._chain = function(name, condition, join, negate) {
  var calls = this.calls;
  var allow = allowed[(calls[0] || name)];
  var ok = _.chain([calls, name]).flatten().all(function(c) {
    return _.chain([allow.list, (calls[0] || name)]).flatten().contains(c).value();
  }).value();
  if (!ok || (allow.list.length === 1 && calls.length === 2 && !allow.chain) || (calls.length === 1 && calls[0] === name)) {
    var display = (allow.list.length === 1 && calls.length === 2 && !allow.chain) ? calls[0] + '/' + calls[1] : calls[0];
    throw new Error('IllegalMethodException: ' + name + ' cannot be chained with ' + display);
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
};

Indeed.prototype.and = function(condition) {
  return this._chain('and', condition, 'and');
};

Indeed.prototype.andNot = function(condition) {
  return this._chain('andNot', condition, 'and', true);
};

Indeed.prototype.butNot = function(condition) {
  return this._chain('butNot', condition, 'and', true);
};

Indeed.prototype.or = function(condition) {
  return this._chain('or', condition, 'or');
};

Indeed.prototype.orNot = function(condition) {
  return this._chain('orNot', condition, 'or', true);
};

Indeed.prototype.xor = function(condition) {
  return this._chain('xor', condition, 'xor');
};

Indeed.prototype.indeed = function(condition) {
  return this._chain('indeed', condition);
};

Indeed.prototype.either = function(condition) {
  return this._chain('either', condition);
};

Indeed.prototype.neither = function(condition) {
  return this._chain('neither', condition, true);
};

Indeed.prototype.nor = function(condition) {
  return this._chain('nor', condition, 'and', true);
};

Indeed.prototype.also = function(condition) {
  return this._chain('also', condition, 'and');
};

Indeed.prototype.else = function(condition) {
  return this._chain('else', condition);
};

Indeed.prototype.both = function(condition) {
  return this._chain('both', condition);
};

Indeed.prototype.allOf = function(condition) {
  return this._rewrite('allOf', condition, function(conditions) {
    return _(conditions).all();
  });
};

Indeed.prototype.oneOf = function(condition) {
  return this._rewrite('oneOf', condition, function(conditions) {
    return _(conditions).countBy(function(cond) {
      return !!cond ? 'true' : 'false';
    }).true === 1;
  });
};

Indeed.prototype.anyOf = function(condition) {
  return this._rewrite('anyOf', condition, function(conditions) {
    return _(conditions).any();
  });
};

Indeed.prototype.noneOf = function(condition) {
  return this._rewrite('noneOf', condition, function(conditions) {
    return _(conditions).all(function(c) {
      return !c;
    });
  });
};

Indeed.prototype._rewrite = function(method, condition, testFunc) {
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
};

Indeed.prototype.eval = 
Indeed.prototype.val = 
Indeed.prototype.test;

module.exports = indeed;
