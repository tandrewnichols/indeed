var utils = require('./utils');

var neither = function(condition) {
  return new Neither(condition);
};

var Neither = function Neither(condition) {
  this.conditions = [condition];
};

Neither.prototype = {
  nor: function(condition) {
    if (this.conditions.length === 2) {
      throw new Error('IllegalMethodException: nor cannot be called with neither/nor');
    } else {
      this.conditions.push(condition);
      return this;
    }
  },

  test: function() {
    return !this.conditions[0] && !this.conditions[1];
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

module.exports = neither;
