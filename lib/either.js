var util = require('util');
var Base = require('./base');

var Either = function Either(condition) {
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
    if (this.current.length === 2 && !this.flags.chain) {
      return this.test();
    } else {
      return this;
    }
  }
};

Either.prototype.test = function() {
  return this.current[0].val || this.current[1].val;
};

var either = module.exports = function(condition) {
  return new Either(condition);
};

either.chain = function(condition) {
  var e = new Either(condition);
  e.flags.chain = true;
  return e;
};

either.Either = Either;
