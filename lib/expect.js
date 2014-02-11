var Indeed = require('./indeed').Indeed,
    util = require('util'),
    _ = require('underscore');

var expect = function(condition) {
  return new Expect(condition);
};

expect.not = function(condition) {
  return new Expect(condition, true);
};

expect.Not = function(condition) {
  var i = new Expect(condition);
  i.groupNegate = true;
  return i;
};

var Expect = expect.Expect = function Expect (condition) {
  Indeed.call(this, condition);
  this.__defineGetter__('to', function() {
    return this;
  });
  this.__defineGetter__('have', function() {
    return this;
  });
  this.__defineGetter__('been', function() {
    return this;
  });
  if (~['spy', 'stub'].indexOf(condition.displayName)) {
    _(this).extend(condition);
  }
};

util.inherits(Expect, Indeed);

Expect.prototype.throw =
Expect.prototype.throws = function (condition) {
  var self = this;
  return this._compare('throw', function(fn) {
    if (typeof fn === 'function') {
      try {
        if (self.throwArgs) {
          fn.apply(fn, self.throwArgs);
        } else {
          fn();
        }
        return false;
      } catch (e) {
        var err = (e instanceof Error) ? e : new Error(e);
        if (condition) {
          switch (condition.constructor.name) {
            case 'Error':
              return _(err).isEqual(condition);
            case 'String':
              return err.message === condition;
            case 'RegExp':
              return condition.test(err.message);
            case 'Function':
              return condition(err);
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

Expect.prototype.with = function() {
  this.throwArgs = [].slice.call(arguments);
  return this;
};

Expect.prototype.property = function(key) {
  return this.containsKey(key);
};

Expect.prototype.match = function(regex) {
  return this._compare('match', function(val) {
    return regex.test(val);
  });
};

Expect.prototype.assert = Expect.prototype.test;
Expect.prototype.be = Expect.prototype.is;
Expect.prototype.equal = Expect.prototype.equals;
Expect.prototype.beA = Expect.prototype.isA;
Expect.prototype.beAn = Expect.prototype.isAn;
Expect.prototype.contain = Expect.prototype.contains;
Expect.prototype.containKey = Expect.prototype.containsKey;
Expect.prototype.containValue = Expect.prototype.containsValue;
Expect.prototype.beDefined = Expect.prototype.isDefined;
Expect.prototype.beUndefined = Expect.prototype.isUndefined;
Expect.prototype.beNull = Expect.prototype.beNull;
Expect.prototype.beNotNull = Expect.prototype.beNotNull;
Expect.prototype.beTrue = Expect.prototype.beTrue;
Expect.prototype.beFalse = Expect.prototype.beFalse;
Expect.prototype.beGreaterThan = Expect.prototype.beGt = Expect.prototype.isGt;
Expect.prototype.beLessThan = Expect.prototype.beLt = Expect.prototype.isLt;
Expect.prototype.beGreaterThanOrEqualTo = Expect.prototype.beGte = Expect.prototype.isGte;
Expect.prototype.beLessThanOrEqualTo = Expect.prototype.beLte = Expect.prototype.isLte;

module.exports = expect;
