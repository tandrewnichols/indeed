var _ = require('underscore'),
    util = require('util'),
    Base = require('./base');

var n = function(count) {
  return new NOf(count);
};

var NOf = n.NOf = function NOf(count) {
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
  return _.chain(this.current).pluck('val').countBy(function(cond) {
    return !!cond ? 'true' : 'false';
  }).value().true === this.count;
};

module.exports = n;
