global.lib = require '../../lib'
global.lib()
global.xpect = global.expect
global.expect = require('chai').expect
global.sinon = require('sinon')
global._ = require 'lodash'
