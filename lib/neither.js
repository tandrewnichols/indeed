var util = require('util');
var utils = require('./utils');
var Base = require('./base');

/**
 * Neither
 *
 * @constructor
 * @param {*} condition - The condition to be evaluated
 * 
 */
var Neither = function Neither(condition) {
  Base.call(this, condition, true);
};

util.inherits(Neither, Base);

/**
 * Neither#nor
 *
 * Add the contrary condition to the chain
 *
 * @param {*} condition - The condition to be evaluated
 * @returns {Neither}
 *
 */
Neither.prototype.nor = function (condition) {
  return this._testIllegalMethod('nor', 'neither/nor', true, condition);
};

/**
 * Neither#test
 *
 * Evaluate the result of the current boolean expression.
 * @returns {boolean}
 *
 */
Neither.prototype.test = function() {
  return !this.current[0].val && !this.current[1].val;
};

/**
 * ~neither
 *
 * The main entry point for neither
 *
 * @param {*} condition - The thing to be evaluated
 * @returns {Neither}
 *
 */
var neither = module.exports = function(condition) {
  return new Neither(condition);
};

// Add chaining and expose constructor
neither.chain = utils.chain(Neither);
neither.Neither = Neither;
