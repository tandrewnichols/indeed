var _ = require('underscore'),
    utils = require('./utils');

var n = function(count) {
  return new NOf(count);
};

var NOf = function NOf(count) {
  this.count = count;
  this.conditions = [];
};

NOf.prototype = {
  of: function(condition) {
    if (this.conditions.length > 0) {
      throw new Error('IllegalMethodException: of cannot be called with of/and');
    } else {
      this.conditions.push(condition);
      return this;
    }
  },

  and: function(condition) {
    this.conditions.push(condition);
    return this;
  },

  test: function() {
    return _(this.conditions).countBy(function(cond) {
      return !!cond ? 'true' : 'false';
    }).true === this.count;

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

n.NOf = NOf;
module.exports = n;
