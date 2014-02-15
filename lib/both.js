var util = require('util'),
    Base = require('./base');

var both = function(condition) {
  return new Both(condition);
};

both.chain = function(condition) {
  var b = new Both(condition);
  b.flags.chain = true;
  return b;
};

var Both = both.Both = function Both(condition) {
  Base.call(this, condition);
};

util.inherits(Both, Base);

Both.prototype.and = function(condition) {
  if (this.current.length === 2) {
    throw new Error('IllegalMethodException: and cannot be called with both/and');
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

Both.prototype.test = function() {
  return this.current[0].val && this.current[1].val;
};

module.exports = both;
