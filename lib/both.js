var util = require('util');
var utils = require('./utils');
var Base = require('./base');

/**
 * Both
 *
 * @constructor
 * 
 */
var Both = function Both(condition) {
  Base.call(this, condition);
};

util.inherits(Both, Base);

/**
 * Both#and
 *
 * Add another condition to the chain
 *
 * @param {*} condition - The condition to be evaluated
 * @returns {Both}
 *
 */
Both.prototype.and = function(condition) {
  return this._testIllegalMethod('and', 'both/and', false, condition);
};

/**
 * Both#test
 *
 * Evaluate the result of the current boolean expression.
 * @returns {boolean}
 *
 */
Both.prototype.test = function() {
  return this.current[0].val && this.current[1].val;
};

/**
 * ~both
 *
 * The main entry point for both
 *
 * @param {*} condition - The thing to be evaluated
 * @returns {Both}
 *
 */
var both = module.exports = function(condition) {
  return new Both(condition);
};

// Add chaining and expose constructor
both.chain = utils.chain(Both);
both.Both = Both;
