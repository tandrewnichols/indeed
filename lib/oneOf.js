var _ = require('lodash');
var util = require('util');
var Base = require('./base');

var oneOf = function(condition) {
  return new OneOf(condition);
};

var OneOf = oneOf.OneOf = function OneOf(condition) {
  Base.call(this, condition);
};

util.inherits(OneOf, Base);

OneOf.prototype.and = function(condition) {
  this.current.push({
    val: condition,
    actual: condition
  });
  return this;
};

OneOf.prototype.test = function() {
  return _(this.current).pluck('val').countBy(function(cond) {
    return !!cond ? 'true': 'false';
  }).value()['true'] === 1;
};

module.exports = oneOf;
