var util = require('util'),
    Base = require('./base');

var either = function(condition) {
  return new Either(condition);
};

var Either = either.Either = function Either(condition) {
  Base.call(this, condition);
};

util.inherits(Either, Base);

Either.prototype.or = function(condition) {
  if (this.current.length === 2) {
    throw new Error('IllegalMethodException: or cannot be called with either/or');
  } else {
    this.current.push({
      val: condition,
      actual: condition
    });
    return this;
  }
};

Either.prototype.test = function() {
  return this.current[0].val || this.current[1].val;
};

module.exports = either;
