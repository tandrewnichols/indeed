var _ = require('lodash');
var Base = require('./base');
var util = require('util');
var allowed = require('./allowed');

// Mixin comparison methods for evaluating chains easily
_.mixin({
  and: function(a, b) {
    return Boolean(a && b);
  },
  or: function(a, b) {
    return Boolean(a || b);
  },
  xor: function(a, b) {
    return Boolean((a || b) && !(a && b));
  }
});

/**
 * ~indeed
 *
 * The main entry point
 *
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
var indeed = function(condition) {
  return new Indeed(condition);
};

/**
 *
 * .not
 *
 * The entry point with the first condition negated
 *
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
indeed.not = function(condition) {
  return new Indeed(condition, true);
};

/**
 * .Not
 *
 * The entry point with the first group negated
 *
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
indeed.Not = function(condition) {
  var i = new Indeed(condition);
  i.flags.groupNot = true;
  return i;
};

/**
 *
 * .chain
 *
 * The entry point with chaining enabled
 *
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
indeed.chain = function(condition) {
  var i = new Indeed(condition);
  i.flags.chain = true;
  return i;
};

/**
 * .not.chain
 *
 * The entry point with chaining enabled and the first condition negated
 *
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
indeed.not.chain = function(condition) {
  var i = new Indeed(condition, true);
  i.flags.chain = true;
  return i;
};

/**
 * .Not.chain
 *
 * The entry point with chaining enabled and the first group negated
 *
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
indeed.Not.chain = function(condition) {
  var i = new Indeed(condition);
  i.flags.groupNot = true;
  i.flags.chain = true;
  return i;
};

/**
 * .mixin
 *
 * Adds custom comparison functions to the Indeed object
 *
 * @param {Object} obj - An object where the keys are the function names to add to the prototype and the values are the functions to execute
 *
 */
indeed.mixin = function(obj) {
  _(obj).keys().each(function(key) {
    var fn = function(condition) {
      return this._compare(obj[key](condition), key);
    };
    Base.prototype[key] = fn;
  }).value();
};

/**
 * Indeed
 *
 * @constructor
 * 
 */
var Indeed = indeed.Indeed = function Indeed () {
  // Setup initial values
  Base.apply(this, arguments);
  var self = this;
  this.calls = ['indeed'];
  this.previous = [];
  this.canChainComparisons = true;

  // Define getters for grouping
  _.each(['And', { name: 'But', join: 'and' }, 'Or', 'Xor'], function(getter) {
    var name = typeof getter === 'string' ? getter : getter.name;
    var join = typeof getter === 'string' ? name.toLowerCase() : getter.join;
    self.__defineGetter__(name, function() {
      self.previous.push({ val: self.test(true), join: join });
      self.calls = [];
      return self;
    });
  });

  // Define some additional getters that do nother except return self,
  // so that chaining sounds more natural.
  _.each(['andDoes', 'andShould', 'andHas', 'andHave', 'andIs', 'andTo', 'andBe'], function(getter) {
    self.__defineGetter__(getter, function() {
      return self;
    });
  });
};

util.inherits(Indeed, Base);

/**
 * Indeed#test
 *
 * Evaluate the result of the current boolean expression.
 * @param {boolean} currentOnly - Evaluate only the current part of the chain, not any previous groups
 * @returns {boolean}
 *
 */
Indeed.prototype.test = function(currentOnly) {
  // Get the last value and, optionally, negate it
  var last = this.current.pop();
  var xored = _.xor(last.val, last.negate);

  // If there's more than one boolean evaluation in this group, evaluate the net result,
  // including the last value popped off above
  if (this.current.length) {
    var current = this._recursivelyCompare(this.current, this.current.pop());
    xored = _[last.join](current, xored);
  }

  // Account for the entire group potentially being negated
  var val = _.xor(xored, this.flags.groupNot);

  // If we have previous chains and currentOnly was not supplied,
  // evaluate all the groups together
  if (this.previous.length && !currentOnly) {
    var method = _.last(this.previous).join;
    var result = this._recursivelyCompare(this.previous, this.previous.pop(), true);
    return _[method](result, val);
  } else {
    // If currentOnly is passed in, we're done. Don't evaluate any previous chains.
    return val; 
  }
};

/**
 * Indeed#_recursivelyCompare
 *
 * Recursively evaluate any the current group or previous groups
 * @private
 *
 */
Indeed.prototype._recursivelyCompare = function(list, item, last) {
  // If there are additional items, grab the next one and recurse;
  // otherwise, we're done. Return the result of the comparisons.
  if (list.length) {
    var method = last ? _.last(list).join : item.join;
    var result = this._recursivelyCompare(list, list.pop(), last);
    var joined = _[method](result, item.val);
    return _.xor(joined, item.negate);
  } else {
    return _.xor(item.val, item.negate);
  }
};

/**
 * Indeed#_chain
 *
 * Generic wrapper for chaining.
 * Methods like 'and' and 'andNot' below delegate to this method.
 * Besides handling the semantics of chaining, this function is
 * responsible for enforcing good grammar. :) No 'either/and' allowed.
 * @private
 * @param {string} name - The name of the function being invoked.
 * @param {*} condition - The value of the current group/chain.
 * @param {string} [join] - The type of logic to perform when evaluating this param against future groups
 * @param {boolean} negate - Whether the group/chain is negated.
 * @returns {Indeed}
 *
 */
Indeed.prototype._chain = function(name, condition, join, negate) {
  // Get the list of current calls.
  // This will be something like ['indeed', 'and', 'and'] or ['either', 'or'].
  var calls = this.calls;

  // Get the mapping object for the original function, which is the first call,
  // or, if this IS the first call, name.
  var allow = allowed[(calls[0] || name)];
  var grammaticallyCorrect = _.all(calls.concat(name), function(c) {
    return _.contains(allow.list.concat(calls[0] || name), c);
  });

  // If this method is grammatically incorrect (e.g. 'either/and')
  // or exceeds the length allowed (e.g. 'either/or/or')
  // or is chained with another starting method (e.g. 'either/neither'),
  // throw an exception.
  if (!grammaticallyCorrect || (allow.list.length === 1 && calls.length === 2 && !allow.chain) || (calls.length === 1 && calls[0] === name)) {
    // If exceeded length is the reason we're throwing, display the pair (e.g. "and" cannot be chained with "neither/nor");
    // otherwise, just display the original call (e.g. "either" cannot be chained with "indeed")
    var display = (allow.list.length === 1 && calls.length === 2 && !allow.chain) ? calls[0] + '/' + calls[1] : calls[0];
    throw new Error('IllegalMethodException: "' + name + '" cannot be chained with "' + display + '"');
  } else {
    // Setup the state for the next chain. Save the current val/actual combo,
    // plus the type of join and whether to negate in the "current" array
    // and add this call to the list of calls.
    var obj = {
      val: condition,
      actual: condition
    };
    if (typeof join === 'string') {
      obj.join = join;
      obj.negate = negate;
    }
    if (typeof join === 'boolean') {
      obj.negate = join;
    }
    this.current.push(obj);
    this.calls.push(name);
    return this;
  }
};

/**
 * Indeed#and
 *
 * Chain with 'and' logic
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
Indeed.prototype.and = function(condition) {
  this.flags.chain = true;
  return this._chain('and', condition, 'and');
};


/**
 * Indeed#andNot
 *
 * Chain with 'and' logic, but negate
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
Indeed.prototype.andNot = function(condition) {
  this.flags.chain = true;
  return this._chain('andNot', condition, 'and', true);
};

/**
 * Indeed#butNot
 *
 * Chain with 'and' logic and negate
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
Indeed.prototype.butNot = function(condition) {
  this.flags.chain = true;
  return this._chain('butNot', condition, 'and', true);
};

/**
 * Indeed#or
 *
 * Chain with 'or' logic
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
Indeed.prototype.or = function(condition) {
  this.flags.chain = true;
  return this._chain('or', condition, 'or');
};

/**
 * Indeed#orNot
 *
 * Chain with 'or' logic but negate
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
Indeed.prototype.orNot = function(condition) {
  this.flags.chain = true;
  return this._chain('orNot', condition, 'or', true);
};

/**
 * Indeed#xor
 *
 * Chain with 'xor' logic
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
Indeed.prototype.xor = function(condition) {
  this.flags.chain = true;
  return this._chain('xor', condition, 'xor');
};

/**
 * Indeed#indeed
 *
 * Begin a new group after chaining
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
Indeed.prototype.indeed = function(condition) {
  return this._chain('indeed', condition);
};

/**
 * Indeed#either
 *
 * Begin a new group after chaining
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
Indeed.prototype.either = function(condition) {
  return this._chain('either', condition);
};

/**
 * Indeed#neither
 *
 * Begin a new group after chaining
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
Indeed.prototype.neither = function(condition) {
  return this._chain('neither', condition, true);
};

/**
 * Indeed#nor
 *
 * Chain with 'and' logic but negate
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
Indeed.prototype.nor = function(condition) {
  return this._chain('nor', condition, 'and', true);
};

/**
 * Indeed#also
 *
 * Chain with 'and' logic
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
Indeed.prototype.also = function(condition) {
  return this._chain('also', condition, 'and');
};

/**
 * Indeed#else
 *
 * Begin a new group after chaining
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
Indeed.prototype['else'] = function(condition) {
  return this._chain('else', condition);
};

/**
 * Indeed#both
 *
 * Begin a new group after chaining
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
Indeed.prototype.both = function(condition) {
  return this._chain('both', condition);
};

/**
 * Indeed#allOf
 *
 * Begin a new group after chaining, requiring all conditions to evaluate true
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
Indeed.prototype.allOf = function(condition) {
  return this._rewrite('allOf', condition, function(conditions) {
    return _.all(conditions);
  });
};

/**
 * Indeed#oneOf
 *
 * Begin a new group after chaining, requiring exactly one condition to evaluate true
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
Indeed.prototype.oneOf = function(condition) {
  return this._rewrite('oneOf', condition, function(conditions) {
    return _.countBy(conditions, function(cond) {
      return Boolean(cond) ? 'true' : 'false';
    })['true'] === 1; 
  });
};

/**
 * Indeed#anyOf
 *
 * Begin a new group after chaining, requiring any one condition to evaluate true
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
Indeed.prototype.anyOf = function(condition) {
  return this._rewrite('anyOf', condition, function(conditions) {
    return _.any(conditions);
  });
};

/**
 * Indeed#noneOf
 *
 * Begin a new group after chaining, requiring all conditions to evaluate false
 *
 * @param {*} condition - The thing to be evaluated
 * @returns {Indeed}
 *
 */
Indeed.prototype.noneOf = function(condition) {
  return this._rewrite('noneOf', condition, function(conditions) {
    return _.all(conditions, function(c) {
      return !c;
    });
  });
};

/**
 * Indeed#_rewrite
 *
 * Overwrites some existing methods during this group only.
 * This is necessary to make existing functions on this class
 * function as expected with methods that really belong on other
 * classes. E.g. The 'and' function should operate differently
 * after calling 'allOf' then it does normally.
 *
 * @param {string} method - The method being invoked. Passed on to _chain.
 * @param {*} condition - The thing to be evaluated
 * @param {Function} testFunc - The function that will evaluate the conditions when "test" is called
 * @returns {Indeed}
 *
 */
Indeed.prototype._rewrite = function(method, condition, testFunc) {
  var _and = this.and;
  var _test = this.test;
  var conditions = [condition];
  this.and = function(cond) {
    conditions.push(cond);
    return this;
  };
  this.test = function() {
    this.and = _and;
    this.test = _test;
    this.current = [{
      val: testFunc(conditions),
      actual: ''
    }];
    return this.test();
  };
  return this._chain(method, condition);
};

/**
 * Indeed#val
 *
 * @alias test
 *
 */
Indeed.prototype.val = Indeed.prototype.test;

module.exports = indeed;
