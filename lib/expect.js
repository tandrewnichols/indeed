var Indeed = require('./indeed').Indeed;
var util = require('util');
var utils = require('./utils');
var _ = require('lodash');

/**
 * Expect
 *
 * @constructor
 * @param {*} condition - The condition to be evaluated
 * 
 */
var Expect = function Expect (condition) {
  Indeed.apply(this, arguments);
  this.calls = ['expect'];

  // Duck-typing: condition is a sinon spy
  if (condition && condition.displayName && condition.args && condition.calledWith) {
    _.extend(this, condition);
  }
};

util.inherits(Expect, Indeed);

/**
 * Expect#throw, Expect#throws
 *
 * Assert that a function throws an exception
 *
 * @param {*} condition - The condition to be evaluated
 * @returns {(Expect|boolean)}
 *
 */
Expect.prototype['throw'] =
Expect.prototype.throws = function (exception) {
  var self = this;
  return this._compare(function(fn) {
    if (typeof fn === 'function') {
      try {
        // Try calling the function, with arguments
        // if there are any
        if (self.throwArgs) {
          fn.apply(fn, self.throwArgs);
        } else {
          fn();
        }
        return false;
      } catch (e) {
        // Catch the exception and evaluate based on the constructor
        var err = (e instanceof Error) ? e : new Error(e);
        if (exception && exception.constructor) {
          switch (exception.constructor.name) {
            case 'Error':
              return _.isEqual(err, exception);
            case 'String':
              return err.message === exception;
            case 'RegExp':
              return exception.test(err.message);
            case 'Function':
              return exception(err);
            default:
              return false;
          }
        } else {
          return true;
        }
      }
    } else {
      return false;
    }
  });
};

/**
 * Expect#with
 *
 * Provide arguments to pass to the function to evaluate with fn.
 *
 * @param {*[]} condition - Any number of arguments to evaluate with throws
 * @returns {Expect}
 *
 */
Expect.prototype['with'] = function() {
  this.throwArgs = [].slice.call(arguments);
  return this;
};

/**
 * Expect#assert
 *
 * Test the condition chain via #test . . . but in a testier way
 *
 * @returns {boolean}
 *
 */
Expect.prototype.assert = Expect.prototype.test;

/**
 * ~expect
 *
 * The main entry point for expect
 *
 * @param {*} condition - The thing to be evaluated
 * @returns {Expect}
 *
 */
var expect = module.exports = function(condition) {
  return new Expect(condition);
};

// Add chaining and negation, and expose constructor
expect.not = function(condition) {
  return new Expect(condition, true);
};

expect.Not = utils.groupNegate(Expect);
expect.chain = utils.chain(Expect);
expect.not.chain = utils.chainNegate(Expect);
expect.Not.chain = utils.groupChainNegate(Expect);
expect.Expect = Expect;
