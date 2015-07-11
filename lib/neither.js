var util = require('util');
var Base = require('./base');

var Neither = function Neither(condition) {
  Base.call(this, condition, true);
};

util.inherits(Neither, Base);

Neither.prototype.nor = function (condition) {
  return this._testIllegalMethod('nor', 'neither/nor', true, condition);
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
