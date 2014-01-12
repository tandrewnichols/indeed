
module.exports = {
  makeGlobal: function() {
    global.indeed = require('./indeed');
    global.either = require('./either');
    global.neither = require('./neither');
    global.both = require('./both');
    global.noneOf = require('./noneOf');
    global.allOf = require('./allOf');
    global.anyOf = require('./anyOf');
    global.oneOf = require('./oneOf');
    global.nOf = require('./nOf');
  },

  delegate: function(condition, join) {
    var i = new (require('./indeed')).Indeed(true);
    i.previous.push({ val: condition, join: join });
    i.calls = [];
    return i;
  }
};
