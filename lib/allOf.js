var _ = require('lodash');
var Base = require('./base');
var util = require('util');

var allOf = function(condition) {
  return new AllOf(condition);
};

var AllOf = allOf.AllOf = function AllOf (condition) {
  Base.call(this, condition);
};

util.inherits(AllOf, Base);

AllOf.prototype.and = function(condition) {
  this.current.push({
    val: condition,
    actual: condition
  });
  return this;
};

AllOf.prototype.test = function () {
  return _(this.current).pluck('val').every(function(cond) {
    return !!cond;
  });
};

module.exports = allOf;
