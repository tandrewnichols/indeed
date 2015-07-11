var util = require('util');
var Base = require('./base');

var Neither = function Neither(condition) {
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
    if (this.current.length === 2 && !this.flags.chain) {
      return this.test();
    } else {
      return this;
    }
  }
};

Neither.prototype.test = function() {
  return !this.current[0].val && !this.current[1].val;
};

var neither = module.exports = function(condition) {
  return new Neither(condition);
};

neither.chain = function(condition) {
  var n = new Neither(condition);
  n.flags.chain = true;
  return n;
};

neither.Neither = Neither;
