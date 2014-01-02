var indeed = function(condition) {
  return new Indeed(condition);
};

var Indeed = function Indeed (condition) {
  this.test = function() {
    return condition;
  };
};

Indeed.prototype.and = function(condition) {
  var prev = this.test();
  this.test = function() {
    return prev && condition;
  };
  return this;
};

Indeed.prototype.or = function(condition) {
  var prev = this.test();
  this.test = function() {
    return prev || condition;
  };
  return this;
};

Indeed.prototype.butNot = function(condition) {
  var prev = this.test();
  this.test = function() {
    return prev && !condition;
  };
  return this;
};

Indeed.prototype.andNot = Indeed.prototype.butNot;

module.exports = indeed;
