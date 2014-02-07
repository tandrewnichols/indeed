var util = require('util'),
    Base = require('./base');

var neither = function(condition) {
  return new Neither(condition);
};

var Neither = neither.Neither = function Neither(condition) {
  Base.call(this, condition, true);
};

util.inherits(Neither, Base);

Neither.prototype.nor = function (condition) {
  if (this.current.length === 2) {
    throw new Error('IllegalMethodException: nor cannot be called with neither/nor');
  } else {
    this.current.push({
      val: condition,
      actual: condition,
      negate: true
    });
    return this;
  }
};

Neither.prototype.test = function() {
  return !this.current[0].val && !this.current[1].val;
};

module.exports = neither;
