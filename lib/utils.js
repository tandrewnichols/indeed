exports.delegate = function(condition, join) {
  var i = new (require('./indeed')).Indeed(true);
  i.current = [];
  i.previous.push({ val: condition, join: join });
  i.calls = [];
  i.flags.chain = true;
  return i;
};
