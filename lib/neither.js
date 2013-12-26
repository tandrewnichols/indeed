module.exports = function(cond1) {
  return {
    nor: function(cond2) {
      return !cond1 && !cond2;
    }
  };
};
