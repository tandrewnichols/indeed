module.exports = {
  delegate: function(condition, join) {
    var i = new (require('./indeed')).Indeed(true);
    i.current = [];
    i.previous.push({ val: condition, join: join });
    i.calls = [];
    return i;
  }
};
