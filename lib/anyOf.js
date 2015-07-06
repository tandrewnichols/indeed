var _ = require('lodash');
var util = require('util');
var Base = require('./base');

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
  return _(this.current).pluck('val').any(function(cond) {
    return !!cond;
  });
};

module.exports = anyOf;
