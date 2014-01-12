var utils = require('./utils');

var both = function(condition) {
  return new Both(condition);
};

var Both = function Both(condition) {
  this.conditions = [condition];
};

Both.prototype = {
  and: function(condition) {
    if (this.conditions.length === 2) {
      throw new Error('IllegalMethodException: and cannot be called with both/and');
    } else {
      this.conditions.push(condition);
      return this;
    }
  },

  test: function() {
    return this.conditions[0] && this.conditions[1];
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

module.exports = both;
