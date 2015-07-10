var _ = require('lodash');
var util = require('util');
var Base = require('./base');

var AnyOf = function AnyOf(condition) {
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
    return Boolean(cond);
  });
};

var anyOf = module.exports = function(condition) {
  return new AnyOf(condition); 
};

anyOf.AnyOf = AnyOf;
