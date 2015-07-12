var util = require('util');
var utils = require('./utils');
var Base = require('./base');

/**
 * Either
 *
 * @constructor
 * @param {*} condition - The condition to be evaluated
 * 
 */
var Either = function Either(condition) {
  Base.call(this, condition);
};

util.inherits(Either, Base);

/**
 * Either#or
 *
 * Add an or condition to the chain
 *
 * @param {*} condition - The condition to be evaluated
 * @returns {Either}
 *
 */
Either.prototype.or = function(condition) {
  return this._testIllegalMethod('or', 'either/or', false, condition);
};

/**
 * Either#test
 *
 * Evaluate the result of the current boolean expression.
 * @returns {boolean}
 *
 */
Either.prototype.test = function() {
  return this.current[0].val || this.current[1].val;
};

/**
 * ~either
 *
 * The main entry point for either
 *
 * @param {*} condition - The thing to be evaluated
 * @returns {Either}
 *
 */
var either = module.exports = function(condition) {
  return new Either(condition);
};

// Add chaining and expose constructor
either.chain = utils.chain(Either);
either.Either = Either;
