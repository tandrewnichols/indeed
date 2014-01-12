var _ = require('underscore'),
    indeed = require('./indeed'),
    utils = require('./utils');

var allOf = function(condition) {
  return new AllOf(condition);
};

var AllOf = function AllOf (condition) {
  this.conditions = [condition];
};

AllOf.prototype = {
  and: function(condition) {
    this.conditions.push(condition);
    return this;
  },

  test: function () {
    return _(this.conditions).every(function(cond) {
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

allOf.AllOf = AllOf;
module.exports = allOf;
