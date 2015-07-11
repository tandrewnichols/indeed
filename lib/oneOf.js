var _ = require('lodash');
var util = require('util');
var Base = require('./base');

var OneOf = function OneOf(condition) {
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
    return Boolean(cond) ? 'true': 'false';
  }).value()['true'] === 1;
};

var oneOf = module.exports = function(condition) {
  return new OneOf(condition);
};

oneOf.OneOf = OneOf;
