var _ = require('lodash');
var util = require('util');
var Base = require('./base');

/**
 * OneOf
 *
 * @constructor
 * @param {*} condition - The condition to be evaluated
 * 
 */
var OneOf = function OneOf(condition) {
  Base.call(this, condition);
};

util.inherits(OneOf, Base);

/**
 * OneOf#and
 *
 * Add another condition to the chain
 *
 * @param {*} condition - The condition to be evaluated
 * @returns {OneOf}
 *
 */
OneOf.prototype.and = function(condition) {
  this.current.push({
    val: condition,
    actual: condition
  });
  return this;
};

/**
 * OneOf#test
 *
 * Evaluate the result of the current boolean expression.
 * @returns {boolean}
 *
 */
OneOf.prototype.test = function() {
  return _(this.current).pluck('val').countBy(function(cond) {
    return Boolean(cond) ? 'true': 'false';
  }).value()['true'] === 1;
};

/**
 * ~oneOf
 *
 * The main entry point for oneOf
 *
 * @param {*} condition - The thing to be evaluated
 * @returns {OneOf}
 *
 */
var oneOf = module.exports = function(condition) {
  return new OneOf(condition);
};

// Expose constructor
oneOf.OneOf = OneOf;
