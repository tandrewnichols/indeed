var util = require('util');
var utils = require('./utils');
var Base = require('./base');

var Either = function Either(condition) {
  Base.call(this, condition);
};

util.inherits(Either, Base);

Either.prototype.or = function(condition) {
  return utils.commonTest.call(this, 'or', 'either/or', false, condition);
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
