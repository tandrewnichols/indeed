neither = require('./../lib/neither')
should = require('should')

describe 'neither', ->
  it 'should accept a boolean and return an object with nor', ->
    neither(true).should.be.an.Object
    neither(true).nor.should.be.a.Function

  describe 'nor', ->
    context 'both are false', ->
      it 'should return true', ->
        neither(false).nor(false).test().should.be.true
    context 'one is false', ->
      it 'should return false', ->
        neither(false).nor(true).test().should.be.false
    context 'both are true', ->
      it 'should return false', ->
        neither(true).nor(true).test().should.be.false

    context 'called multiple times', ->
      ( ->
        neither(true).nor(true).nor(true)
      ).should.throw('IllegalMethodException: nor cannot be called with neither/nor')

  describe '#And', ->
    it 'should delegate to indeed an and', ->
      neither(true).nor(false).And.indeed(true).and(true).test().should.be.false

  describe '#Or', ->
    it 'should delegate to indeed with an or', ->
      neither(true).nor(false).Or.else(true).or(false).test().should.be.true

  describe '#Xor', ->
    it 'should delegate to indeed with an xor', ->
      neither(true).nor(false).Xor.indeed(true).or(false).test().should.be.true
