var _ = require('lodash');
var util = require('util');
var Base = require('./base');

/**
 * NoneOf
 *
 * @constructor
 * @param {*} condition - The condition to be evaluated
 * 
 */
var NoneOf = function NoneOf(condition) {
  Base.call(this, condition);
};

util.inherits(NoneOf, Base);

/**
 * NoneOf#and
 *
 * Add another condition to the chain
 *
 * @param {*} condition - The condition to be evaluated
 * @returns {NoneOf}
 *
 */
NoneOf.prototype.and = function(condition) {
  this.current.push({
    val: condition,
    actual: condition
  });
  return this;
};

/**
 * NoneOf#test
 *
 * Evaluate the result of the current boolean expression.
 * @returns {boolean}
 *
 */
NoneOf.prototype.test = function() {
  return _(this.current).pluck('val').every(function(cond) {
    return !cond;
  });
};

/**
 * ~noneOf
 *
 * The main entry point for noneOf
 *
 * @param {*} condition - The thing to be evaluated
 * @returns {NoneOf}
 *
 */
var noneOf = module.exports = function(condition) {
  return new NoneOf(condition);
};

// Expose constructor
noneOf.NoneOf = NoneOf;
