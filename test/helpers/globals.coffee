global._indeed = require '../../lib'
global._indeed()
global.xpect = global.expect
global.expect = require('chai').expect
global.sinon = require('sinon')
global._ = require 'lodash'
