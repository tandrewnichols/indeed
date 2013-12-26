var _ = require('underscore'),
    //nOf = require('./nOf'),
    conditions = [];

var generateReturnFn = function(cond1) {
  conditions.push(cond1);
  return {
    and: function(cond2) {
      return generateReturnFn(cond2);
    },
    test: function() {
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
