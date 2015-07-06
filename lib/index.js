var globalize = function() {
  var root = typeof window === 'object' ? window : global;
  root.indeed = require('./indeed');
  root.expect = require('./expect');
  root.either = require('./either');
  root.neither = require('./neither');
  root.both = require('./both');
  root.noneOf = require('./noneOf');
  root.allOf = require('./allOf');
  root.anyOf = require('./anyOf');
  root.oneOf = require('./oneOf');
  root.n = require('./nOf');
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
