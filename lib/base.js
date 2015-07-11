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
  var self = this;
  this.flags = {
    not: false,
    deep: false,
    chain: false,
    noCase: false
  };
  this.current = [{
    val: condition,
    negate: negate,
    actual: condition
  }];
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
 * @returns {(Base|*)}
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

Base.prototype._testIllegalMethod = function(currentMethod, prevMethods, negate, condition) {
  if (this.current.length === 2) {
    throw new Error('IllegalMethodException: "' + currentMethod + '" cannot be called with "' + prevMethods + '"');
  } else {
    var obj = {
      val: condition,
      actual: condition
    };

    if (negate) {
      obj.negate = negate;
    }

    this.current.push(obj);

    if (this.current.length === 2 && !this.flags.chain) {
      return this.test();
    } else {
      return this;
    }
  }
};

Base.prototype.equals = Base.prototype.equal = Base.prototype.eql = function(condition) {
  var self = this,
      cond, v;
  return this._compare(function(val) {
    if (self.flags.noCase && _.isString(val)) {
      cond = condition.toLowerCase();
      v = val.toLowerCase();
    }
    if (self.flags.deep) {
      self.flags.deep = false;
      return _.isEqual(( v || val ), ( cond || condition ));
    } else {
      return (v || val) === (cond || condition);
    }
  });
};

Base.prototype.matches = Base.prototype.match = function(regex) {
  if (typeof regex === 'string') {
    regex = new RegExp(regex);
  }
  return this._compare(function(val) {
    return regex.test(val);
  });
};

Base.prototype.a = Base.prototype.an = function(condition) {
  return this._compare(function(val) {
    try {
      return val.constructor.name.toLowerCase() === condition.toLowerCase();
    } catch (e) {
      return typeof val === condition && val !== null && typeof val !== 'undefined';
    }
  });
};

Base.prototype.contains = Base.prototype.contain = Base.prototype.indexOf = function(condition) {
  var self = this,
      cond, v;
  return this._compare(function(val) {
    if (self.flags.noCase && _.isString(val)) {
      cond = condition.toLowerCase();
      v = val.toLowerCase();
    }
    if (val.indexOf) {
      return (v || val).indexOf(( cond || condition )) > -1;
    } else {
      return false;
    }
  });
};

Base.prototype.containsKey = Base.prototype.containKey = Base.prototype.key = Base.prototype.property = function(condition) {
  var self = this;
  return this._compare(function(val) {
    if (_.isObject(val)) {
      if (self.flags.noCase) {
        var c = condition.toLowerCase();
        return _(val).keys().any(function(k) {
          return k.toLowerCase() === c;
        });
      } else {
        return condition in val;
      }
    } else {
      return false;
    }
  });
};

Base.prototype.containsKeys = Base.prototype.containKeys = Base.prototype.keys = Base.prototype.properties = function() {
  var args = _.isArray(arguments[0]) ? arguments[0] : [].slice.call(arguments);
  var self = this;
  return this._compare(function(val) {
    if (_.isObject(val)) {
      if (self.flags.noCase) {
        return _.every(args, function(condition) {
          var c = condition.toLowerCase();
          return _(val).keys().any(function(k) {
            return k.toLowerCase() === c;
          });
        });
      } else {
        return _.every(args, function(condition) {
          return condition in val;
        });
      }
    } else {
      return false;
    }
  });
};


Base.prototype.containsValue = Base.prototype.containValue = Base.prototype.value = function(condition) {
  var self = this;
  return this._compare(function(val) {
    if (_.isObject(val)) {
      if (self.flags.noCase) {
        var c = condition.toLowerCase();
        return _(val).values().any(function(v) {
          return v.toLowerCase() === c;
        });
      } else {
        return _(val).values().contains(condition);
      }
    } else {
      return false;
    }
  });
};

Base.prototype.containsValues = Base.prototype.containValues = Base.prototype.values = function() {
  var args = _.isArray(arguments[0]) ? arguments[0] : [].slice.call(arguments);
  var self = this;
  return this._compare(function(val) {
    if (_.isObject(val)) {
      if (self.flags.noCase) {
        return _.every(args, function(condition) {
          var c = condition.toLowerCase();
          return _(val).values().any(function(v) {
            return v.toLowerCase() === c;
          });
        });
      } else {
        return _.every(args, function(condition) {
          return _.values(val).indexOf(condition) > -1;
        });
      }
    } else {
      return false;
    }
  });
};

Base.prototype.defined = function() {
  return this._compare(function(val) {
    return typeof val !== 'undefined';
  });
};

Base.prototype['null'] = function() {
  return this._compare(function(val) {
    return val === null;
  });
};

Base.prototype['true'] = function() {
  return this._compare(function(val) {
    return val === true;
  });
};

Base.prototype['false'] = function() {
  return this._compare(function(val) {
    return val === false;
  });
};

Base.prototype.truthy = function() {
  return this._compare(function(val) {
    return val ? true : false;
  });
};

Base.prototype.falsy = function() {
  return this._compare(function(val) {
    return val ? false : true;
  });
};

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

Base.prototype.greaterThan = Base.prototype.gt = Base.prototype.above = _evalRelation('gt');
Base.prototype.lessThan = Base.prototype.lt = Base.prototype.below = _evalRelation('lt');
Base.prototype.greaterThanOrEqualTo = Base.prototype.gte = _evalRelation('gte');
Base.prototype.lessThanOrEqualTo = Base.prototype.lte = _evalRelation('lte');

Base.prototype.tap = function(fn) {
  fn(this);
  return this;
};

module.exports = Base;
