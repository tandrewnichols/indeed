var _ = require('lodash');
var Base = require('./base');
var util = require('util');

/**
 * AllOf
 *
 * @constructor
 * @param {*} condition - The condition to be evaluated
 * 
 */
var AllOf = function AllOf (condition) {
  Base.call(this, condition);
};

util.inherits(AllOf, Base);

/**
 * AllOf#and
 *
 * Add another condition to the chain
 *
 * @param {*} condition - The condition to be evaluated
 * @returns {AllOf}
 *
 */
AllOf.prototype.and = function(condition) {
  this.current.push({
    val: condition,
    actual: condition
  });
  return this;
};

/**
 * AllOf#test
 *
 * Evaluate the result of the current boolean expression.
 * @returns {boolean}
 *
 */
AllOf.prototype.test = function () {
  return _(this.current).pluck('val').every(function(cond) {
    return Boolean(cond);
  });
};

/**
 * ~allOf
 *
 * The main entry point for allOf
 *
 * @param {*} condition - The thing to be evaluated
 * @returns {AllOf}
 *
 */
var allOf = module.exports = function(condition) {
  return new AllOf(condition);
};

// Expose constructor
allOf.AllOf = AllOf;
