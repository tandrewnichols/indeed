var _ = require('lodash');
var util = require('util');
var Base = require('./base');

var NOf = function NOf(count) {
  this.count = count;
};

util.inherits(NOf, Base);

NOf.prototype.of = function(condition) {
  if (this.current) {
    throw new Error('IllegalMethodException: of cannot be called with of/and');
  } else {
    Base.call(this, condition);
    return this;
  }
};

NOf.prototype.and = function(condition) {
  this.current.push({
    val: condition,
    actual: condition
  });
  return this;
};

NOf.prototype.test = function() {
  return _(this.current).pluck('val').countBy(function(cond) {
    return Boolean(cond) ? 'true' : 'false';
  }).value()['true'] === this.count;
};

var n = module.exports = function(count) {
  return new NOf(count);
};

n.NOf = NOf;
