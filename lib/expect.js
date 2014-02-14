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
  i.flags.groupNot = true;
  return i;
};

var Expect = expect.Expect = function Expect (condition) {
  Indeed.call(this, condition);
  if (~['spy', 'stub'].indexOf(condition.displayName)) {
    _(this).extend(condition);
  }
};

util.inherits(Expect, Indeed);

Expect.prototype.throw =
Expect.prototype.throws = function (condition) {
  var self = this;
  return this._compare(function(fn) {
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

Expect.prototype.assert = Expect.prototype.test;

module.exports = expect;
