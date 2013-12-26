neither = require('./../lib/neither')
should = require('should')

describe 'neither', ->
  it 'should accept a boolean and return an object with nor', ->
    neither(true).should.be.an.Object
    neither(true).nor.should.be.a.Function

  describe 'nor', ->
    context 'both are false', ->
      it 'should return true', ->
        neither(false).nor(false).should.be.true
    context 'one is false', ->
      it 'should return false', ->
        neither(false).nor(true).should.be.false
    context 'both are true', ->
      it 'should return false', ->
        neither(true).nor(true).should.be.false
