var _ = require('underscore'),
    indeed = require('./indeed'),
    utils = require('./utils');

var anyOf = function(condition) {
  return new AnyOf(condition); 
};

var AnyOf = function AnyOf(condition) {
  this.conditions = [condition];
};

AnyOf.prototype = {
  and: function(condition) {
    this.conditions.push(condition);
    return this;
  },

  test: function() {
    return _(this.conditions).any(function(cond) {
      return !!cond;
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

module.exports = anyOf;
