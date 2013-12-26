var _ = require('underscore'),
    conditions = [];

var generateReturnFn = function(cond1) {
  conditions.push(cond1);
  return {
    and: function(cond2) {
      return generateReturnFn(cond2);
    },
    test: function() {
      var bool = _(conditions).any(function(cond) {
        return !!cond;
      });
      conditions = [];
      return bool;
    }
  };
};

var anyOf = function(condition) {
  return generateReturnFn(condition);
};

anyOf.reset = function() {
  conditions = [];
};

module.exports = anyOf;
