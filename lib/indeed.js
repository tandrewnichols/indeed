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
  indeed: {
    list: ['and', 'andNot', 'or', 'orNot', 'butNot'],
    chain: true
  },
  also: {
    list: ['and', 'andNot', 'or', 'orNot', 'butNot'],
    chain: true
  },
  else: {
    list: ['and', 'andNot', 'or', 'orNot', 'butNot'],
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
    var calls = this.calls;
    var allow = allowed[(calls[0] || name)];
    var ok = _.chain([calls, name]).flatten().all(function(c) {
      return _.chain([allow.list, (calls[0] || name)]).flatten().contains(c).value();
    }).value();
    if (!ok || (allow.list.length === 1 && calls.length === 2 && !allow.chain) || (calls.length === 1 && calls[0] === name)) {
      var display = (allow.list.length === 1 && calls.length === 2 && !allow.chain) ? calls[0] + '/' + calls[1] : calls[0];
      throw new Error('IllegalMethodException: ' + name + ' cannot be called with ' + display);
    } else {
      this.current = join ? _[join](this.current, condition) : condition;
      this.calls.push(name);
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
    return this._run('indeed', condition);
  },

  either: function(condition) {
    return this._run('either', condition);
  },

  neither: function(condition) {
    return this._run('neither', !condition);
  },

  nor: function(condition) {
    return this._run('nor', !condition, 'and');
  },

  also: function(condition) {
    return this._run('also', condition, 'and');
  },

  else: function(condition) {
    return this._run('else', condition);
  },

  both: function(condition) {
    return this._run('both', condition);
  },

  allOf: function(condition) {
    return this._run('allOf', condition);
  },

  get And() {
    this.previous.push({ val: this.current, join: 'and' });
    this.calls = [];
    return this;
  },

  get Or() {
    this.previous.push({ val: this.current, join: 'or' });
    this.calls = [];
    return this;
  },

  get Xor() {
    this.previous.push({ val: this.current, join: 'xor' });
    this.calls = [];
    return this;
  },

  get Not() {
    this.groupNegate = true;
    return this;
  }
};

Indeed.prototype.eval = Indeed.prototype.val = Indeed.prototype.test;

module.exports = indeed;
