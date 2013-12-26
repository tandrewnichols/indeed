anyOf = require('./../lib/anyOf')

describe 'anyOf', ->
  beforeEach ->
    anyOf.reset()

  it 'should return an object with and', ->
    anyOf(true).should.be.an.Object
    anyOf(true).and.should.be.a.Function
    anyOf(true).test.should.be.a.Function
    anyOf.reset.should.be.a.Function

  describe '.and', ->
    context 'none true', ->
      it 'should return false', ->
        anyOf(false).and(false).test().should.be.false
    context 'one true', ->
      it 'should return true', ->
        anyOf(true).and(false).test().should.be.true
    context 'all true', ->
      it 'should return true', ->
        anyOf(true).and(true).test().should.be.true

  context 'called more than once', ->
    it 'should reset conditions after test', ->
      anyOf(false).and(false).test().should.be.false
      anyOf(true).and(false).test().should.be.true

  describe '.reset', ->
    it 'should reset conditions', ->
      anyOf(false).and(false)
      anyOf.reset()
      anyOf(true).and(false).test().should.be.true
