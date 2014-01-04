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

var Indeed = indeed.Indeed = function Indeed (condition, negate) {
  this.previous = [];
  this.current = condition ^ negate;
};

Indeed.prototype = {
  test: function() {
    var self = this;
    if (this.previous.length) {
      var start = this.previous.shift();
      this.previous.push(function(condition) {
        return condition && !!(self.current ^ self.groupNegate);
      });
      return _(this.previous).reduce(function(memo, prev) {
        return prev(memo);
      }, start());
    } else {
      return !!(this.current ^ this.groupNegate);    
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
    var self = this;
    var i = new Indeed(condition);
    i.previous.push(function(cond) {
      if (cond) {
        return self.current && cond;
      } else {
        return self.current;
      }
    });
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
