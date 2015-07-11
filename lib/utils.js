exports.delegate = function(condition, join) {
  var i = new (require('./indeed')).Indeed(true);
  i.current = [];
  i.previous.push({ val: condition, join: join });
  i.calls = [];
  i.flags.chain = true;
  return i;
};

exports.commonTest = function(currentMethod, prevMethods, negate, condition) {
  if (this.current.length === 2) {
    throw new Error('IllegalMethodException: "' + currentMethod + '" cannot be called with "' + prevMethods + '"');
  } else {
    var obj = {
      val: condition,
      actual: condition
    };

    if (negate) {
      obj.negate = negate;
    }

    this.current.push(obj);

    if (this.current.length === 2 && !this.flags.chain) {
      return this.test();
    } else {
      return this;
    }
  }
};
