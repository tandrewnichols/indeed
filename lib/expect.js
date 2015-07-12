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
  var self = this;
  Indeed.apply(this, arguments);
  this.calls = ['expect'];

  // Duck-typing: condition is a sinon spy
  if (condition && condition.displayName && condition.args && condition.calledWith) {
    // Extend expect with spy assertions
    _.extend(this, condition);

    // We need to change the functionality of "not" for spies, because
    // expect(spy).not.to.have.been.called doesn't act as expected otherwise.
    this.__defineGetter__('not', function() {
      // Still set this flag in case, by some chance,
      // a build in method is called instead
      self.flags.not = true;

      // Wrapper to create a function for negating spy methods
      var createFunc = function(fn) {
        // Save off the existing spy method as __functionName
        var newName = '__' + fn;
        self[newName] = self[fn];

        // This is the actual function that will be called when,
        // for example, calledWith() is invoked
        return function() {
          var func = self[newName];
          
          // If this thing is a function, invoke it with all arguments;
          // otherwise, just grab the value of the property.
          var val = typeof func === 'function' ? func.apply(condition, arguments) : func;

          // Negate and return
          return !val;
        };
      };

      // Thought about saving a literal list of spy functions to replace,
      // but I don't want this lib to be dependent on a particular version
      // of sinon. So instead, we're just doing them all, which should be safe
      // since this only happens when "not" is called. But . . . it would
      // be weird to do expect(spy).not.to.yieldTo(/*...*/) or such.
      for (var fn in condition) {
        if (condition.hasOwnProperty(fn)) {
          // Keep the API the same as sinon. If this thing is a function,
          // replace it with a function. If it's a property, replace it with
          // a getter, so that every can be used exactly the same way.
          if (typeof condition[fn] === 'function') {
            self[fn] = createFunc(fn);
          } else {
            self.__defineGetter__(fn, createFunc(fn));
          }
        }
      }

      // For chaining purposes.
      return this;
    });
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
