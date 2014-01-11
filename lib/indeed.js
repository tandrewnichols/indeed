var _ = require('underscore');
_.mixin({
  compare: function(list, previous) {
    if (list.length) {
      var b = _[previous.join](_(list).compare(list.shift()), previous.val);
      return b;
    } else {
      return previous.val;
    }
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
  indeed: ['and', 'andNot', 'or', 'orNot', 'butNot'],
  also: ['and', 'andNot', 'or', 'orNot', 'butNot'],
  else: ['and', 'andNot', 'or', 'orNot', 'butNot'],
  either: ['or'],
  neither: ['nor'],
  both: ['and'],
  allOf: ['and'],
  oneOf: ['and'],
  anyOf: ['and']
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
  this.current = !!(condition ^ negate);
  this.calls = ['indeed'];
};

Indeed.prototype = {
  test: function() {
    var val = !!(this.current ^ this.groupNegate);
    if (this.previous.length) {
      return _[_(this.previous).last().join](_(this.previous).compare(this.previous.shift()), val);
    } else {
      return val; 
    }
  },

  _run: function(name, condition, join) {
    var called = _([this.calls, name]).flatten();
    var allow = _([allowed[this.calls[0]], this.calls[0]]).flatten();
    var ok = _(called).all(function(c) {
      var i = ~allow.indexOf(c);
      if (i) {
        allow.splice(i, 1);
        return true;
      } else {
        return false;
      }
    });
    if (!ok) {
      var display = allowed[this.calls[0]].length === 1 ? this.calls[0] + '/' + this.calls[1] : this.calls[0];
      throw new Error('IllegalMethodException: ' + display + ' cannot be called with ' + name);
    } else {
      this.current = join ? _[join](this.current, condition) : condition;
      return this;
    }
  },

  and: function(condition) {
    return this._run('and', condition, 'and');
  },
  
  andNot: function(condition) {
    return this._run('andNot', !condition, 'and');
  },

  butNot: function(condition) {
    return this._run('butNot', !condition, 'and');
  },

  or: function(condition) {
    return this._run('or', condition, 'or');
  },

  orNot: function(condition) {
    return this._run('orNot', !condition, 'or');
  },

  indeed: function(condition) {
    this.calls = ['indeed'];
    return this._run('indeed', condition);
  },

  either: function(condition) {
    this.calls = ['either'];
    return this._run('either', condition);
  },

  neither: function(condition) {
    this.calls = ['neither'];
    return this._run('neither', !condition);
  },

  nor: function(condition) {
    return this._run('nor', !condition, 'and');
  },

  also: function(condition) {
    this.calls = ['also'];
    return this._run('also', condition, 'and');
  },

  else: function(condition) {
    this.calls = ['else'];
    return this._run('else', condition);
  },

  both: function(condition) {
    this.calls = ['both'];
    return this._run('both', condition);
  },

  get And() {
    this.previous.push({ val: this.current, join: 'and' });
    return this;
  },

  get Or() {
    this.previous.push({ val: this.current, join: 'or' });
    return this;
  },

  get Xor() {
    this.previous.push({ val: this.current, join: 'xor' });
    return this;
  },

  get Not() {
    this.groupNegate = true;
    return this;
  }
};

Indeed.prototype.eval = Indeed.prototype.val = Indeed.prototype.test;

module.exports = indeed;
