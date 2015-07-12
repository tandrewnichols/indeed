var _ = require('lodash');
var util = require('util');
var Base = require('./base');

/**
 * N
 *
 * @constructor
 * @param {number} count - The number of truthy conditions to expect
 * 
 */
var N = function N(count) {
  this.count = count;
};

util.inherits(N, Base);

/**
 * N#of
 *
 * Start a series
 *
 * @param {*} condition - The condition to be evaluated
 * @returns {N}
 *
 */
N.prototype.of = function(condition) {
  if (this.current) {
    throw new Error('IllegalMethodException: "of" cannot be called with "of/and"');
  } else {
    Base.call(this, condition);
    return this;
  }
};

/**
 * N#and
 *
 * Add another condition to the chain
 *
 * @param {*} condition - The condition to be evaluated
 * @returns {N}
 *
 */
N.prototype.and = function(condition) {
  this.current.push({
    val: condition,
    actual: condition
  });
  return this;
};

/**
 * N#test
 *
 * Evaluate the result of the current boolean expression.
 * @returns {boolean}
 *
 */
N.prototype.test = function() {
  return _(this.current).pluck('val').countBy(function(cond) {
    return Boolean(cond) ? 'true' : 'false';
  }).value()['true'] === this.count;
};

/**
 * ~n
 *
 * The main entry point for n
 *
 * @param {*} condition - The thing to be evaluated
 * @returns {N}
 *
 */
var n = module.exports = function(count) {
  return new N(count);
};

// Expose constructor
n.N = N;
