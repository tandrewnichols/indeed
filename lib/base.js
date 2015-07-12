var _ = require('lodash');
var utils = require('./utils');

/**
 * Base
 *
 * Underlying class for the other boolean helpers
 * @private
 * @constructor
 * @param {*} condition - The thing to be evaluated
 * @param {boolean} negate - Whether the first group is negated
 *
 */
var Base = function Base(condition, negate) {
  // Set up flags
  var self = this;
  this.flags = {
    not: false,
    deep: false,
    chain: false,
    noCase: false
  };

  // Add this condition to the current list
  this.current = [{
    val: condition,
    negate: negate,
    actual: condition
  }];

  // Set up helpers
  _.each(['And', 'But', 'Or', 'Xor'], function(joiner) {
    self.__defineGetter__(joiner, function() {
      return utils.delegate(self.test(), joiner.toLowerCase());
    });
  });
  _.each(['does', 'should', 'has', 'have', 'is', 'to', 'be', 'been'], function(getter) {
    self.__defineGetter__(getter, function() {
      return self;
    });
  });
  _.each(['deep', 'deeply'], function(getter) {
    self.__defineGetter__(getter, function() {
      self.flags.deep = true;
      return self;
    });
  });
  self.__defineGetter__('not', function() {
    self.flags.not = true;
    return self;
  });
  self.__defineGetter__('Not', function() {
    self.flags.groupNot = true;
    return this;
  });
  _.each(['noCase', 'caseless'], function(getter) {
    self.__defineGetter__(getter, function() {
      self.flags.noCase = true;
      return self;
    });
  });
};

/**
 * Base#_compare
 *
 * Handles the comparison of actual and expected
 *
 * @param {Function} tester = The function that evaluates the condition
 * @returns {(Base|boolean)}
 *
 */
Base.prototype._compare = function(tester) {
  // Evaluate the current value via the tester
  var current = this.current.pop();
  var newVal = tester(current.actual);

  // Handle negation if necessary and reset any flags
  current.val = this.flags.not ? !newVal : Boolean(newVal);
  this.flags.not = false;
  this.flags.noCase = false;

  // If chaining, return the instance;
  // otherwise, return the value
  if (!this.flags.chain && this.canChainComparisons) {
    return current.val;
  } else {
    this.current.push(current);
    return this;
  }
};

/**
 * Base#_testIllegalMethod
 *
 * Assert that a particular function can be called. If not, throw an exception;
 * otherwise, test the current chain.
 *
 * @private
 * @param {string} currentMethod - The method being invoked
 * @param {string} prevMethods - The methods called prior to this
 * @param {boolean} negate - Set "negate" on the "current" object
 * @param {*} condition - The condition to be evaluated
 * @returns {(Base|boolean)}
 *
 */
Base.prototype._testIllegalMethod = function(currentMethod, prevMethods, negate, condition) {
  // If two methods have already been called, throw an exception
  if (this.current.length === 2) {
    throw new Error('IllegalMethodException: "' + currentMethod + '" cannot be called with "' + prevMethods + '"');
  } else {
    // Otherwise, add to the list of current objects
    var obj = {
      val: condition,
      actual: condition
    };

    if (negate) {
      obj.negate = negate;
    }

    this.current.push(obj);

    // If we're not chaining, test
    if (this.current.length === 2 && !this.flags.chain) {
      return this.test();
    } else {
      return this;
    }
  }
};

/**
 * Base#equal, Base#equal, Base#eql
 * 
 * Assert equality
 *
 * @param {*} expected - The expected value of the current condition
 * @returns {boolean}
 *
 */
Base.prototype.equals = Base.prototype.equal = Base.prototype.eql = function(expected) {
  var self = this;
  var cond;
  var v;

  return this._compare(function(val) {
    // If noCase was set, lowercase all the things
    if (self.flags.noCase && _.isString(val)) {
      cond = expected.toLowerCase();
      v = val.toLowerCase();
    }
    
    // If this is a deep comparison, delegate to _.isEqual;
    // otherwise, use type/value comparison
    if (self.flags.deep) {
      self.flags.deep = false;
      return _.isEqual(( v || val ), ( cond || expected ));
    } else {
      return (v || val) === (cond || expected);
    }
  });
};

/**
 * Base#matches, Base#match
 *
 * Assert that condition matches a pattern
 *
 * @param {string|RegExp} regex - The pattern to test against
 * @returns {(Base|boolean)}
 *
 */
Base.prototype.matches = Base.prototype.match = function(regex) {
  // If the regex is a string, convert it to a RegExp
  if (typeof regex === 'string') {
    regex = new RegExp(regex);
  }

  return this._compare(function(val) {
    return regex.test(val);
  });
};

/**
 * Base#a, Base#an
 *
 * Assert that the condition is of a particular type
 *
 * @param {string} type - The type expected
 * @returns {(Base|boolean)}
 *
 */
Base.prototype.a = Base.prototype.an = function(type) {
  return this._compare(function(val) {
    try {
      // Try comparing the constructor name first
      return val.constructor.name.toLowerCase() === type.toLowerCase();
    } catch (e) {
      // If that fails, try typeof
      return typeof val === type && val !== null && typeof val !== 'undefined';
    }
  });
};

/**
 * Base#contains, Base#contain, Base#indexOf
 *
 * Assert that the condition contains a substring
 *
 * @param {string} substr - The substring to check for
 * @returns {(Base|boolean)}
 *
 */
Base.prototype.contains = Base.prototype.contain = Base.prototype.indexOf = function(substring) {
  var self = this;
  var cond;
  var v;

  return this._compare(function(val) {
    // If noCase was set, lowercase all the things
    if (self.flags.noCase && _.isString(val)) {
      cond = substring.toLowerCase();
      v = val.toLowerCase();
    }

    // If this val is a string or array, call indexOf on it
    // otherwise, return false
    if (val.indexOf) {
      return (v || val).indexOf(( cond || substring )) > -1;
    } else {
      return false;
    }
  });
};

/**
 * Base#containsKey, Base#containKey, Base#key, Base#property
 *
 * Assert that an object contains a particular key
 *
 * @param {string} key - The key to look for
 * @returns {(Base|boolean)}
 *
 */
Base.prototype.containsKey = Base.prototype.containKey = Base.prototype.key = Base.prototype.property = function(key) {
  var self = this;
  return this._compare(function(val) {
    if (_.isObject(val)) {
      // If noCase is set, we have to iterate over the keys
      // and check the lowercase of each; otherwise, things
      // are much simpler. We just need to no if the keys is
      // in the object.
      if (self.flags.noCase) {
        var c = key.toLowerCase();
        return _(val).keys().any(function(k) {
          return k.toLowerCase() === c;
        });
      } else {
        return key in val;
      }
    } else {
      return false;
    }
  });
};

/**
 * Base#containsKeys, Base#containKeys, Base#keys, Base#properties
 *
 * Assert that an object contains all of a set of keys
 *
 * @param {string[]|strings} keys - Any number of keys to check for
 * @returns {(Base|boolean)}
 *
 */
Base.prototype.containsKeys = Base.prototype.containKeys = Base.prototype.keys = Base.prototype.properties = function() {
  // Get the list of keys, either the first argument, or ALL the arguments
  var keys = _.isArray(arguments[0]) ? arguments[0] : [].slice.call(arguments);
  var self = this;
  return this._compare(function(val) {
    if (_.isObject(val)) {
      // Similar to containsKey, but we have to iterate over every key
      if (self.flags.noCase) {
        return _.every(keys, function(condition) {
          var c = condition.toLowerCase();
          return _(val).keys().any(function(k) {
            return k.toLowerCase() === c;
          });
        });
      } else {
        return _.every(keys, function(condition) {
          return condition in val;
        });
      }
    } else {
      return false;
    }
  });
};

/**
 * Base#containsValue, Base#containValue, Base#value
 *
 * Assert that an object contains a particular value
 *
 * @param {*} value - The value to check for
 * @returns {(Base|boolean)}
 *
 */
Base.prototype.containsValue = Base.prototype.containValue = Base.prototype.value = function(value) {
  return this._compare(function(val) {
    if (_.isObject(val)) {
      // Check that the list of values contains the value in question
      return _(val).values().contains(value);
    } else {
      return false;
    }
  });
};

/**
 * Base#containsValues, Base#containValues, Base#values
 *
 * Assert that an object contains all of a set of values
 *
 * @param {*[]} values - The list of values to check for
 * @returns {(Base|boolean)}
 *
 */
Base.prototype.containsValues = Base.prototype.containValues = Base.prototype.values = function() {
  var values = _.isArray(arguments[0]) ? arguments[0] : [].slice.call(arguments);
  return this._compare(function(val) {
    if (_.isObject(val)) {
      // Check that the list of values contains all the values in question
      return _.every(values, function(condition) {
        return _.values(val).indexOf(condition) > -1;
      });
    } else {
      return false;
    }
  });
};

/**
 * Base#defined
 *
 * Assert on the definedness of the condition
 *
 * @returns {(Base|boolean)}
 *
 */
Base.prototype.defined = function() {
  return this._compare(function(val) {
    return typeof val !== 'undefined';
  });
};

/**
 * Base#null
 *
 * Assert that the condition is null
 *
 * @returns {(Base|boolean)}
 *
 */
Base.prototype['null'] = function() {
  return this._compare(function(val) {
    return val === null;
  });
};

/**
 * Base#true
 *
 * Assert that the condition is true
 *
 * @returns {(Base|boolean)}
 *
 */
Base.prototype['true'] = function() {
  return this._compare(function(val) {
    return val === true;
  });
};

/**
 * Base#false
 *
 * Assert that the condition is false
 *
 * @returns {(Base|boolean)}
 *
 */
Base.prototype['false'] = function() {
  return this._compare(function(val) {
    return val === false;
  });
};

/**
 * Base#truthy
 *
 * Assert that the condition is truthy
 *
 * @returns {(Base|boolean)}
 *
 */
Base.prototype.truthy = function() {
  return this._compare(function(val) {
    return val ? true : false;
  });
};

/**
 * Base#falsy
 *
 * Assert that the condition is falsy
 *
 * @returns {(Base|boolean)}
 *
 */
Base.prototype.falsy = function() {
  return this._compare(function(val) {
    return val ? false : true;
  });
};

/**
 * ~_evalRelation
 *
 * Generic wrapper for evaluating lessThan, greaterThan, lessThanOrEqualTo, and greaterThanOrEqualTo
 *
 * @param {string} op - The operator, one of 'gt', 'lt', 'gte', and 'lte'
 * @returns {function}
 *
 */
var _evalRelation = function (op) {
  return function(condition) {
    return this._compare(function(val) {
      var isNum = _.isNumber(val);
      switch (op) {
        case 'gt':
          return isNum && val > condition;
        case 'lt':
          return isNum && val < condition;
        case 'gte':
          return isNum && val >= condition;
        default:
          return isNum && val <= condition;
      }
    });
  };
};

/**
 * Base#greaterThan, Base#gt, Base#above
 *
 * Assert that the condition is greater than a particular value
 *
 * @param {number} value - The value to check against
 * @returns {(Base|boolean)}
 *
 */
Base.prototype.greaterThan = Base.prototype.gt = Base.prototype.above = _evalRelation('gt');

/**
 * Base#lessThan, Base#lt, Base#below
 *
 * Assert that the condition is less than a particular value
 *
 * @param {number} value - The value to check against
 * @returns {(Base|boolean)}
 *
 */
Base.prototype.lessThan = Base.prototype.lt = Base.prototype.below = _evalRelation('lt');

/**
 * Base#greaterThanOrEqualTo, Base#gte
 *
 * Assert that the condition is greater than or equal to a particular value
 *
 * @param {number} value - The value to check against
 * @returns {(Base|boolean)}
 *
 */
Base.prototype.greaterThanOrEqualTo = Base.prototype.gte = _evalRelation('gte');

/**
 * Base#lessThanOrEqualTo, Base#lte
 *
 * Assert that the condition is less than or equal to a particular value
 *
 * @param {number} value - The value to check against
 * @returns {(Base|boolean)}
 *
 */
Base.prototype.lessThanOrEqualTo = Base.prototype.lte = _evalRelation('lte');

/**
 * Base#tap
 *
 * Call a function with the current instance object
 *
 * @param {function} fn - The function to call
 * @returns {Base}
 *
 */
Base.prototype.tap = function(fn) {
  fn(this);
  return this;
};

// export Base
module.exports = Base;
