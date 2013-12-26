var _ = require('underscore'),
    conditions = [];

var generateReturnFn = function(cond1) {
  conditions.push(cond1);
  return {
    and: function(cond2) {
      return generateReturnFn(cond2);
    },
    test: function() {
      var bools = _(conditions).countBy(function(cond) {
        return !!cond ? 'true': 'false';
      });
      conditions = [];
      return bools['true'] === 1;
    }
  };
};

var oneOf = function(condition) {
  return generateReturnFn(condition);
};

oneOf.reset = function() {
  conditions = [];
};

module.exports = oneOf;
