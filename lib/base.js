var _ = require('underscore'),
    utils = require('./utils');

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
  _(['And', 'But', 'Or', 'Xor']).each(function(joiner) {
    self.__defineGetter__(joiner, function() {
      return utils.delegate(self.test(), joiner.toLowerCase());
    });
  });
  _(['does', 'should', 'has', 'have', 'is', 'to', 'be', 'been']).each(function(getter) {
    self.__defineGetter__(getter, function() {
      return self;
    });
  });
  _(['deep', 'deeply']).each(function(getter) {
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
  _(['noCase', 'caseless']).each(function(getter) {
    self.__defineGetter__(getter, function() {
      self.flags.noCase = true;
      return self;
    });
  });
};

Base.prototype._compare = function(tester) {
  var current = this.current.pop();
  var newVal = tester(current.actual);
  current.val = this.flags.not ? !newVal : !!newVal;
  this.flags.not = false;
  this.flags.noCase = false;
  if (!this.flags.chain && this.canChainComparisons) {
    return current.val;
  } else {
    this.current.push(current);
    return this;
  }
};

Base.prototype.equals = Base.prototype.equal = Base.prototype.eql = function(condition) {
  var self = this,
      cond, v;
  return this._compare(function(val) {
    if (self.flags.noCase && _(val).isString()) {
      cond = condition.toLowerCase();
      v = val.toLowerCase();
    }
    if (self.flags.deep) {
      return _(( v || val )).isEqual(( cond || condition ));
    } else {
      return (v || val) === (cond || condition);
    }
    self.flags.deep = false;
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
    if (self.flags.noCase && _(val).isString()) {
      cond = condition.toLowerCase();
      v = val.toLowerCase();
    }
    if (val.indexOf) {
      return !!~(v || val).indexOf(( cond || condition ));
    } else {
      return false;
    }
  });
};

Base.prototype.containsKey = Base.prototype.containKey = Base.prototype.key = Base.prototype.property = function(condition) {
  var self = this;
  return this._compare(function(val) {
    if (_(val).isObject()) {
      if (self.flags.noCase) {
        var c = condition.toLowerCase();
        return _.chain(val).keys().any(function(k) {
          return k.toLowerCase() === c;
        }).value();
      } else {
        return condition in val;
      }
    } else {
      return false;
    }
  });
};

Base.prototype.containsKeys = Base.prototype.containKeys = Base.prototype.keys = Base.prototype.properties = function() {
  var args = _(arguments[0]).isArray() ? arguments[0] : [].slice.call(arguments);
  var self = this;
  return this._compare(function(val) {
    if (_(val).isObject()) {
      if (self.flags.noCase) {
        return _(args).every(function(condition) {
          var c = condition.toLowerCase();
          return _.chain(val).keys().any(function(k) {
            return k.toLowerCase() === c;
          });
        });
      } else {
        return _(args).every(function(condition) {
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
    if (_(val).isObject()) {
      if (self.flags.noCase) {
        var c = condition.toLowerCase();
        return _.chain(val).values().any(function(v) {
          return v.toLowerCase() === c;
        });
      } else {
        return _.chain(val).values().contains(condition).value();
      }
    } else {
      return false;
    }
  });
};

Base.prototype.containsValues = Base.prototype.containValues = Base.prototype.values = function() {
  var args = _(arguments[0]).isArray() ? arguments[0] : [].slice.call(arguments);
  var self = this;
  return this._compare(function(val) {
    if (_(val).isObject()) {
      if (self.flags.noCase) {
        return _(args).every(function(condition) {
          var c = condition.toLowerCase();
          return _.chain(val).values().any(function(v) {
            return v.toLowerCase() === c;
          });
        });
      } else {
        return _(args).every(function(condition) {
          return ~_(val).values().indexOf(condition);
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

Base.prototype.null = function() {
  return this._compare(function(val) {
    return val === null;
  });
};

Base.prototype.true = function() {
  return this._compare(function(val) {
    return val === true;
  });
};

Base.prototype.false = function() {
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

Base.prototype.greaterThan = Base.prototype.gt = Base.prototype.above = function(condition) {
  return this._compare(function(val) {
    return _(val).isNumber() && val > condition;
  });
};

Base.prototype.lessThan = Base.prototype.lt = Base.prototype.below = function(condition) {
  return this._compare(function(val) {
    return _(val).isNumber() && val < condition;
  });
};

Base.prototype.greaterThanOrEqualTo = Base.prototype.gte = function(condition) {
  return this._compare(function(val) {
    return _(val).isNumber() && val >= condition;
  });
};

Base.prototype.lessThanOrEqualTo = Base.prototype.lte = function(condition) {
  return this._compare(function(val) {
    return _(val).isNumber() && val <= condition;
  });
};

Base.prototype.tap = function(fn) {
  fn(this);
  return this;
};

module.exports = Base;
