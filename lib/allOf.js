var _ = require('underscore'),
    conditions = [];

var generateReturnFn = function(cond1) {
  conditions.push(cond1);
  return {
    and: function(cond2) {
      return generateReturnFn(cond2);
    },
    test: function() {
      var bool = _(conditions).every(function(cond) {
        return !!cond;
      });
      conditions = [];
      return bool;
    }
  };
};

var allOf = function(condition) {
  return generateReturnFn(condition);
};

allOf.reset = function() {
  conditions = [];
};

module.exports = allOf;
