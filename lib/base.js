var _ = require('underscore'),
    utils = require('./utils');

var Base = function Base(condition, negate) {
  var self = this;
  this.flags = {
    not: false,
    deep: false
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
  var chain = function() {
    return self;
  };
  Object.defineProperty(chain, 'not', {
    get: function() {
      self.flags.not = true;
      return self;
    }
  });
  _(['should', 'has', 'have', 'is', 'to', 'be', 'been']).each(function(getter) {
    self.__defineGetter__(getter, chain);
  });
  _(['deep', 'deeply']).each(function(getter) {
    self.__defineGetter__(getter, function() {
      self.flags.deep = true;
      return self;
    });
  });
};

Base.prototype._compare = function(tester) {
  var current = this.current.pop();
  if (!current.compare) {
    var newVal = tester(current.actual);
    current.val = this.flags.not ? !newVal : !!newVal;
    current.compare = true;
  } else {
    throw new Error('IllegalMethodException: this method cannot be chained with the previous method.');
  }
  this.flags.not = false;
  this.current.push(current);
  return this;
};

Base.prototype.equals = Base.prototype.equal = Base.prototype.eql = function(condition) {
  var self = this;
  return this._compare(function(val) {
    if (self.flags.deep) {
      return _(val).isEqual(condition);
    } else {
      return val === condition;
    }
    self.flags.deep = false;
  });
};

Base.prototype.matches = Base.prototype.match = function(regex) {
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
  return this._compare(function(val) {
    if (val.indexOf) {
      return !!~val.indexOf(condition);
    } else {
      return false;
    }
  });
};

Base.prototype.containsKey = Base.prototype.containKey = Base.prototype.key = Base.prototype.property = function(condition) {
  return this._compare(function(val) {
    if (_(val).isObject()) {
      return condition in val;
    } else {
      return false;
    }
  });
};

Base.prototype.containsKeys = Base.prototype.containKeys = Base.prototype.keys = Base.prototype.properties = function() {
  var args = _(arguments[0]).isArray() ? arguments[0] : [].slice.call(arguments);
  return this._compare(function(val) {
    if (_(val).isObject()) {
      return _(args).every(function(condition) {
        return condition in val;
      });
    } else {
      return false;
    }
  });
};


Base.prototype.containsValue = Base.prototype.containValue = Base.prototype.value = function(condition) {
  return this._compare(function(val) {
    if (_(val).isObject()) {
      return _.chain(val).values().contains(condition).value();
    } else {
      return false;
    }
  });
};

Base.prototype.containsValues = Base.prototype.containValues = Base.prototype.values = function() {
  var args = _(arguments[0]).isArray() ? arguments[0] : [].slice.call(arguments);
  return this._compare(function(val) {
    if (_(val).isObject()) {
      return _(args).every(function(condition) {
        return ~_(val).values().indexOf(condition);
      });
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
