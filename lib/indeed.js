var _ = require('underscore');

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

indeed['&&'] = function(a, b) {
  return a && b;
};

indeed['||'] = function(a, b) {
  return a || b;
};

var Indeed = indeed.Indeed = function Indeed (condition, negate) {
  this.current = condition ^ negate;
};

Indeed.prototype = {
  test: function() {
    var val = !!(this.current ^ this.groupNegate);
    if (this.previous) {
      return indeed[this.groupCondition](this.previous.test(), val);
    } else {
      return val; 
    }
  },

  and: function(condition) {
    this.current = this.current && condition;
    return this;
  },
  
  andNot: function(condition) {
    this.current = this.current && !condition;
    return this;
  },

  or: function(condition) {
    this.current = this.current || condition;
    return this;
  },

  orNot: function(condition) {
    this.current = this.current || !condition;
    return this;
  },

  butAlso: function(condition) {
    var i = new Indeed(condition);
    i.previous = this;
    i.groupCondition = '&&';
    return i;
  },

  butAlsoNot: function(condition) {
    var i = this.butAlso(condition);
    i.groupNegate = true;
    return i;
  }
};

Indeed.prototype.eval = Indeed.prototype.val = Indeed.prototype.test;

module.exports = indeed;
