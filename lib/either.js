module.exports = function(cond1) {
  return {
    or: function(cond2) {
      return cond1 || cond2;
    }
  };
};
