var _ = require('underscore'),
    utils = require('./utils');

var Base = function Base(condition, negate) {
  var self = this;
  this.current = [{
    val: condition,
    negate: negate,
    actual: condition
  }];
  this.__defineGetter__('And', function() {
    return utils.delegate(this.test(), 'and');
  });
  this.__defineGetter__('But', function() {
    return utils.delegate(this.test(), 'and');
  });
  this.__defineGetter__('Or', function() {
    return utils.delegate(this.test(), 'or');
  });
  this.__defineGetter__('Xor', function() {
    return utils.delegate(this.test(), 'xor');
  });
};

Base.prototype._compare = function(method, tester) {
  var current = this.current.pop();
  if (!current.compare) {
    current.val = tester(current.actual);
    current.compare = method;
  } else {
    throw new Error('IllegalMethodException: ' + method + ' cannot be called with ' + current.compare);
  }
  this.current.push(current);
  return this;
};

Base.prototype.is = Base.prototype.be = function(condition) { 
  return this._compare('is', function(val) {
    return val === condition;
  });
};

Base.prototype.equals = Base.prototype.equal = function(condition) {
  return this._compare('equals', function(val) {
    return _(val).isEqual(condition);
  });
};

Base.prototype.isA = Base.prototype.beA = function(condition) {
  return this._compare('isA', function(val) {
    try {
      return val.constructor.name.toLowerCase() === condition.toLowerCase();
    } catch (e) {
      return typeof val === condition && val !== null && typeof val !== 'undefined';
    }
  });
};

Base.prototype.isAn = Base.prototype.beAn = function(condition) {
  return this._compare('isAn', function(val) {
    try {
      return val.constructor.name.toLowerCase() === condition.toLowerCase();
    } catch (e) {
      return typeof val === condition && val !== null && typeof val !== 'undefined';
    }
  });
};

Base.prototype.contains = Base.prototype.contain = function(condition) {
  return this._compare('contains', function(val) {
    if (val.indexOf) {
      return !!~val.indexOf(condition);
    } else {
      return false
    }
  });
};

Base.prototype.containsKey = Base.prototype.containKey = function(condition) {
  return this._compare('containsKey', function(val) {
    if (_(val).isObject()) {
      return _.chain(val).keys().contains(condition).value();
    } else {
      return false;
    }
  });
};

Base.prototype.containsValue = Base.prototype.containValue = function(condition) {
  return this._compare('containsValue', function(val) {
    if (_(val).isObject()) {
      return _.chain(val).values().contains(condition).value();
    } else {
      return false;
    }
  });
};

Base.prototype.isDefined = Base.prototype.beDefined = function() {
  return this._compare('isDefined', function(val) {
    return typeof val !== 'undefined';
  });
};

Base.prototype.isUndefined = Base.prototype.beUndefined = function() {
  return this._compare('isUndefined', function(val) {
    return typeof val === 'undefined';
  });
};

Base.prototype.isNull = Base.prototype.beNull = function() {
  return this._compare('isNull', function(val) {
    return val === null;
  });
};

Base.prototype.isNotNull = Base.prototype.beNotNull = function() {
  return this._compare('isNull', function(val) {
    return val !== null;
  });
};

Base.prototype.isTrue = Base.prototype.beTrue = function() {
  return this._compare('isTrue', function(val) {
    return val === true;
  });
};

Base.prototype.isFalse = Base.prototype.beFalse = function() {
  return this._compare('isFalse', function(val) {
    return val === false;
  });
};

Base.prototype.isGreaterThan =
Base.prototype.isGt =
Base.prototype.beGreaterThan =
Base.prototype.beGt = function(condition) {
  return this._compare('isGreaterThan', function(val) {
    return _(val).isNumber() && val > condition;
  });
};

Base.prototype.isLessThan =
Base.prototype.isLt =
Base.prototype.beLessThan =
Base.prototype.beLt = function(condition) {
  return this._compare('isLessThan', function(val) {
    return _(val).isNumber() && val < condition;
  });
};

Base.prototype.isGreaterThanOrEqualTo =
Base.prototype.isGte =
Base.prototype.beGreaterThanOrEqualTo =
Base.prototype.beGte = function(condition) {
  return this._compare('isGreaterThanOrEqualTo', function(val) {
    return _(val).isNumber() && val >= condition;
  });
};

Base.prototype.isLessThanOrEqualTo =
Base.prototype.isLte =
Base.prototype.beLessThanOrEqualTo =
Base.prototype.beLte = function(condition) {
  return this._compare('isGreaterThanOrEqualTo', function(val) {
    return _(val).isNumber() && val <= condition;
  });
};

module.exports = Base;
