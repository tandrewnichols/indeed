var _ = require('underscore'),
    util = require('util'),
    Base = require('./base');

var anyOf = function(condition) {
  return new AnyOf(condition); 
};

var AnyOf = anyOf.AnyOf = function AnyOf(condition) {
  Base.call(this, condition);
};

util.inherits(AnyOf, Base);

AnyOf.prototype.and = function(condition) {
  this.current.push({
    val: condition,
    actual: condition
  });
  return this;
};

AnyOf.prototype.test = function() {
  return _.chain(this.current).pluck('val').any(function(cond) {
    return !!cond;
  }).value();
};

module.exports = anyOf;
