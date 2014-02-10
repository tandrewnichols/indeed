var globalize = function() {
  global.indeed = require('./indeed');
  global.expect = require('./expect');
  global.either = require('./either');
  global.neither = require('./neither');
  global.both = require('./both');
  global.noneOf = require('./noneOf');
  global.allOf = require('./allOf');
  global.anyOf = require('./anyOf');
  global.oneOf = require('./oneOf');
  global.n = require('./nOf');
};

globalize.indeed = require('./indeed');
globalize.expect = require('./expect');
globalize.either = require('./either');
globalize.neither = require('./neither');
globalize.both = require('./both');
globalize.noneOf = require('./noneOf');
globalize.allOf = require('./allOf');
globalize.oneOf = require('./oneOf');
globalize.n = require('./nOf');

module.exports = globalize;
