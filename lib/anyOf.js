var _ = require('lodash');
var util = require('util');
var Base = require('./base');

/**
 * AnyOf
 *
 * @constructor
 * @param {*} condition - The condition to be evaluated
 * 
 */
var AnyOf = function AnyOf(condition) {
  Base.call(this, condition);
};

util.inherits(AnyOf, Base);

/**
 * AnyOf#and
 *
 * Add another condition to the chain
 *
 * @param {*} condition - The condition to be evaluated
 * @returns {AnyOf}
 *
 */
AnyOf.prototype.and = function(condition) {
  this.current.push({
    val: condition,
    actual: condition
  });
  return this;
};

/**
 * AnyOf#test
 *
 * Evaluate the result of the current boolean expression.
 * @returns {boolean}
 *
 */
AnyOf.prototype.test = function() {
  return _(this.current).pluck('val').any(function(cond) {
    return Boolean(cond);
  });
};

/**
 * ~anyOf
 *
 * The main entry point for anyOf
 *
 * @param {*} condition - The thing to be evaluated
 * @returns {AnyOf}
 *
 */
var anyOf = module.exports = function(condition) {
  return new AnyOf(condition); 
};

// Expose constructor
anyOf.AnyOf = AnyOf;
