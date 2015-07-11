var util = require('util');
var Base = require('./base');

var Both = function Both(condition) {
  Base.call(this, condition);
};

util.inherits(Both, Base);

Both.prototype.and = function(condition) {
  return this._testIllegalMethod('and', 'both/and', false, condition);
};

Both.prototype.test = function() {
  return this.current[0].val && this.current[1].val;
};

var both = module.exports = function(condition) {
  return new Both(condition);
};

both.chain = function(condition) {
  var b = new Both(condition);
  b.flags.chain = true;
  return b;
};

both.Both = Both;
