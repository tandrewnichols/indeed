var utils = require('./utils'),
    util = require('util'),
    Base = require('./base');

var neither = function(condition) {
  return new Neither(condition);
};

var Neither = function Neither(condition) {
  Base.call(this);
  this.conditions = [condition];
  this.__defineGetter__('And', function() {
    return utils.delegate(this.test(), 'and');
  });
  this.__defineGetter__('Or', function() {
    return utils.delegate(this.test(), 'or');
  });
  this.__defineGetter__('Xor', function() {
    return utils.delegate(this.test(), 'xor');
  });
};

util.inherits(Neither, Base);

Neither.prototype.nor = function (condition) {
  if (this.conditions.length === 2) {
    throw new Error('IllegalMethodException: nor cannot be called with neither/nor');
  } else {
    this.conditions.push(condition);
    return this;
  }
};

Neither.prototype.test = function() {
  return !this.conditions[0] && !this.conditions[1];
};

neither.Neither = Neither;
module.exports = neither;
