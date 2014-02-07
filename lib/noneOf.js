var _ = require('underscore'),
    util = require('util'),
    Base = require('./base');

var noneOf = function(condition) {
  return new NoneOf(condition);
};

var NoneOf = noneOf.NoneOf = function NoneOf(condition) {
  Base.call(this, condition);
};

util.inherits(NoneOf, Base);

NoneOf.prototype.and = function(condition) {
  this.current.push({
    val: condition,
    actual: condition
  });
  return this;
};

NoneOf.prototype.test = function() {
  return _.chain(this.current).pluck('val').every(function(cond) {
    return !cond;
  }).value();
};

module.exports = noneOf;
