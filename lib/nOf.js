var _ = require('underscore'),
    conditions = [];

var generateReturnFunc = function(cond1) {
  conditions.push(cond1);
  return {
    and: function(cond2) {
      return generateReturnFunc(cond2);
    },
    test: function(n) {
      var bools = _(conditions).countBy(function(cond) {
        return !!cond ? 'true' : 'false';
      });
      conditions = [];
      return bools['true'] === n;
    }
  };
};

var nOf = function(condition) {
  return generateReturnFunc(condition);
};

nOf.reset = function() {
  conditions = [];
};

module.exports = nOf;
