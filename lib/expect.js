var Indeed = require('./indeed').Indeed;
var util = require('util');
var utils = require('./utils');
var _ = require('lodash');

var Expect = function Expect (condition) {
  Indeed.apply(this, arguments);
  this.calls = ['expect'];

  // Duck-typing: condition is a sinon spy
  if (condition && condition.displayName && condition.args && condition.calledWith) {
    _.extend(this, condition);
  }
};

util.inherits(Expect, Indeed);

Expect.prototype['throw'] =
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
              return _.isEqual(err, condition);
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

Expect.prototype['with'] = function() {
  this.throwArgs = [].slice.call(arguments);
  return this;
};

Expect.prototype.assert = Expect.prototype.test;

var expect = module.exports = function(condition) {
  return new Expect(condition);
};

expect.not = function(condition) {
  return new Expect(condition, true);
};

expect.Not = utils.groupNegate(Expect);
expect.chain = utils.chain(Expect);
expect.not.chain = utils.chainNegate(Expect);
expect.Not.chain = utils.groupChainNegate(Expect);
expect.Expect = Expect;
