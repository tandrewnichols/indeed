exports.delegate = function(condition, join) {
  var i = new (require('./indeed')).Indeed(true);
  i.current = [];
  i.previous.push({ val: condition, join: join });
  i.calls = [];
  i.flags.chain = true;
  return i;
};

/**
 * .groupNegate
 *
 * The entry point for Indeed and Expect with the first group negated
 *
 * @param {Constructor} Clss - The class to be instantiated
 * @returns {function}
 *
 */
exports.groupNegate = function(Clss) {
  return function(condition) {
    var c = new Clss(condition);
    c.flags.groupNot = true;
    return c;
  };
};

/**
 *
 * .chain
 *
 * The entry point for Indeed and Expect with chaining enabled
 *
 * @param {Constructor} Clss - The class to be instantiated
 * @returns {function}
 *
 */
exports.chain = function(Clss) {
  return function(condition) {
    var c = new Clss(condition);
    c.flags.chain = true;
    return c;
  };
};

/**
 * .chainNegate
 *
 * The entry point for Indeed and Expect with chaining enabled
 * and the first condition negated
 *
 * @param {Constructor} Clss - The class to be instantiated
 * @returns {function}
 *
 */
exports.chainNegate = function(Clss) {
  return function(condition) {
    var c = new Clss(condition, true);
    c.flags.chain = true;
    return c;
  };
};

/**
 * .groupNegate
 *
 * The entry point for Indeed and Expect with chaining enabled and the first group negated
 *
 * @param {Constructor} Clss - The class to be instantiated
 * @returns {function}
 *
 */
exports.groupChainNegate = function(Clss) {
  return function(condition) {
    var c = new Clss(condition);
    c.flags.groupNot = true;
    c.flags.chain = true;
    return c;
  };
};
