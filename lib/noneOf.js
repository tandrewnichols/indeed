var _ = require('underscore'),
    utils = require('./utils');

var noneOf = function(condition) {
  return new NoneOf(condition);
};

var NoneOf = function NoneOf(condition) {
  this.conditions = [condition];
};

NoneOf.prototype = {
  and: function(condition) {
    this.conditions.push(condition);
    return this;
  },

  test: function() {
    return _(this.conditions).every(function(cond) {
      return !cond;
    });
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

noneOf.NoneOf = NoneOf;
module.exports = noneOf;
