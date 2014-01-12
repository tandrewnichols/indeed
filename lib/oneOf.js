var _ = require('underscore'),
    utils = require('./utils');

var oneOf = function(condition) {
  return new OneOf(condition);
};

var OneOf = function OneOf(condition) {
  this.conditions = [condition];
};

OneOf.prototype = {
  and: function(condition) {
    this.conditions.push(condition);
    return this;
  },

  test: function() {
    return _(this.conditions).countBy(function(cond) {
      return !!cond ? 'true': 'false';
    }).true === 1;
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

oneOf.OneOf = OneOf;
module.exports = oneOf;
