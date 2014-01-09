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
  this.allowed = ['and', 'andNot', 'or', 'orNot', 'butNot'];
  this.current = !!(condition ^ negate);
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

  _run: function(name, condition, join, fields) {
    if (_(join).isArray()) {
      fields = join, join = undefined;
    }
    if (!this.allowed || (this.allowed.length && !~this.allowed.indexOf(name))) {
      throw new Error('IllegalMethodException: ' + this.lastCall + ' cannot be called with ' + name);
    } else {
      this.current = join ? _[join](this.current, condition) : condition;
      this.lastCall = name;
      this.allowed = fields || this.allowed;
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
    return this._run('indeed', condition, ['and', 'andNot', 'or', 'orNot', 'butNot']);
  },

  either: function(condition) {
    return this._run('either', condition, ['or']);
  },

  neither: function(condition) {
    return this._run('neither', !condition, ['nor']);
  },

  nor: function(condition) {
    return this._run('nor', !condition, 'and', false);
  },

  also: function(condition) {
    return this._run('also', condition, 'and', false);
  },

  else: function(condition) {
    return this._run('else', condition, ['and', 'andNot', 'or', 'orNot', 'butNot']);
  },

  both: function(condition) {
    return this._run('both', condition, ['and', 'andNot']);
  },

  get And() {
    this.previous.push({ val: this.current, join: 'and' });
    this.allowed = ['indeed', 'also', 'neither', 'either', 'both'];
    return this;
  },

  get Or() {
    this.previous.push({ val: this.current, join: 'or' });
    this.allowed = ['else', 'neither', 'either', 'both']
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
