module.exports = function(cond1) {
  return {
    and: function(cond2) {
      return cond1 && cond2;
    }
  };
};
