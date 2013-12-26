var either = require('./either'),
    neither = require('./neither'),
    both = require('./both'),
    noneOf = require('./noneOf'),
    allOf = require('./allOf'),
    oneOf = require('./oneOf'),
    nOf = require('./nOf');

var glob = function() {
  global.either = either;
  global.neither = neither;
  global.both = both;
  global.noneOf = noneOf;
  global.allOf = allOf;
  global.oneOf = oneOf;
  global.nOf = nOf;
};

glob.either = either;
glob.neither = neither;
glob.both = both;
glob.noneOf = noneOf;
glob.allOf = allOf;
glob.oneOf = oneOf;
glob.nOf = nOf;

module.exports = glob;
