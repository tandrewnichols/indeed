var utils = require('./utils');

var either = function(condition) {
  return new Either(condition);
};

var Either = function Either(condition) {
  this.conditions = [condition];
};

Either.prototype = {
  or: function(condition) {
    if (this.conditions.length === 2) {
      throw new Error('IllegalMethodException: or cannot be called with either/or');
    } else {
      this.conditions.push(condition);
      return this;
    }
  },

  test: function() {
    return this.conditions[0] || this.conditions[1];
  },

  get And() {
    return utils.delegate(this.test(), 'and');
  },
    
  get Or() {
    return utils.delegate(this.test(), 'or');
  },

  get Xor() {
    return utils.delegate(this.test(), 'xor');
  }
};

module.exports = either;
