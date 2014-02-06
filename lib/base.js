var _ = require('underscore');

var Base = function Base() {};

Base.prototype.mixin = function(obj) {
  _.chain(obj).keys().each(function(key) {
    var fn = function(condition) {
      return this._compare(key, obj[key](condition));
    };
    Base.prototype[key] = fn;
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

Base.prototype.is = function(condition) { 
  return this._compare('is', function(val) {
    return val === condition;
  });
};

Base.prototype.equals = function(condition) {
  return this._compare('equals', function(val) {
    return _(val).isEqual(condition);
  });
};

Base.prototype.isA = function(condition) {
  return this._compare('isA', function(val) {
    try {
      return val.constructor.name.toLowerCase() === condition.toLowerCase();
    } catch (e) {
      return typeof val === condition && val !== null && typeof val !== 'undefined';
    }
  });
};

Base.prototype.isAn = function(condition) {
  return this._compare('isAn', function(val) {
    try {
      return val.constructor.name.toLowerCase() === condition.toLowerCase();
    } catch (e) {
      return typeof val === condition && val !== null && typeof val !== 'undefined';
    }
  });
};

Base.prototype.contains = function(condition) {
  return this._compare('contains', function(val) {
    if (val.indexOf) {
      return !!~val.indexOf(condition);
    } else {
      return false
    }
  });
};

Base.prototype.containsKey = function(condition) {
  return this._compare('containsKey', function(val) {
    if (_(val).isObject()) {
      return _.chain(val).keys().contains(condition).value();
    } else {
      return false;
    }
  });
};

Base.prototype.containsValue = function(condition) {
  return this._compare('containsValue', function(val) {
    return _.chain(val).values().contains(condition).value();
  });
};

Base.prototype.isDefined = function() {
  return this._compare('isDefined', function(val) {
    return typeof val !== 'undefined';
  });
};

Base.prototype.isNull = function() {
  return this._compare('isNull', function(val) {
    return val === null;
  });
};

Base.prototype.isNotNull = function() {
  return this._compare('isNull', function(val) {
    return val !== null;
  });
};

Base.prototype.isTrue = function() {
  return this._compare('isTrue', function(val) {
    return val === true;
  });
};

Base.prototype.isFalse = function() {
  return this._compare('isFalse', function(val) {
    return val === false;
  });
};

Base.prototype.isGreaterThan = function(condition) {
  return this._compare('isGreaterThan', function(val) {
    return _(val).isNumber() && val > condition;
  });
};

Base.prototype.isLessThan = function(condition) {
  return this._compare('isGreaterThan', function(val) {
    return _(val).isNumber() && val < condition;
  });
};

Base.prototype.isGreaterThanOrEqualTo = function(condition) {
  return this._compare('isGreaterThanOrEqualTo', function(val) {
    return _(val).isNumber() && val >= condition;
  });
};

Base.prototype.isLessThanOrEqualTo = function(condition) {
  return this._compare('isGreaterThanOrEqualTo', function(val) {
    return _(val).isNumber() && val <= condition;
  });
};

module.exports = Base;
