var either = require('./either'),
    neither = require('./neither'),
    both = require('./both'),
    noneOf = require('./noneOf');

var globe = function() {
  global.either = either;
  global.neither = neither;
  global.both = both;
  global.noneOf = noneOf;
};

globe.either = either;
globe.neither = neither;
globe.both = both;
globe.noneOf = noneOf;

module.exports = globe;
