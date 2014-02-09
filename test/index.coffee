expect = require('chai').expect

describe 'index', ->
  context 'non-global', ->
    it 'should return all helpers in an object', ->
      lib = require('./../lib')
      expect(lib).to.have.property('indeed')
      expect(lib).to.have.property('expect')
      expect(lib).to.have.property('neither')
      expect(lib).to.have.property('either')
      expect(lib).to.have.property('both')
      expect(lib).to.have.property('noneOf')
      expect(lib).to.have.property('allOf')
      expect(lib).to.have.property('oneOf')
      expect(lib).to.have.property('n')

  context 'global', ->
    it 'should set global helpers', ->
      require('./../lib')()
      expect(global.indeed).to.be.a('function')
      expect(global.expect).to.be.a('function')
      expect(global.either).to.be.a('function')
      expect(global.neither).to.be.a('function')
      expect(global.both).to.be.a('function')
      expect(global.noneOf).to.be.a('function')
      expect(global.allOf).to.be.a('function')
      expect(global.anyOf).to.be.a('function')
      expect(global.oneOf).to.be.a('function')
      expect(global.n).to.be.a('function')
