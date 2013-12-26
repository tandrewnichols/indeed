oneOf = require('./../lib/oneOf')

describe 'oneOf', ->
  beforeEach ->
    oneOf.reset()

  it 'should return an object with and', ->
    oneOf(true).should.be.an.Object
    oneOf(true).and.should.be.a.Function
    oneOf(true).test.should.be.a.Function
    oneOf.reset.should.be.a.Function

  describe '.and', ->
    context 'called with all true', ->
      it 'should return false', ->
        oneOf(true).and(true).test().should.be.false
    context 'called with all false', ->
      it 'should return false', ->
        oneOf(false).and(false).test().should.be.false
    context 'called with two true and one false', ->
      it 'should return false', ->
        oneOf(true).and(false).and(true).test().should.be.false
    context 'called with one true', ->
      it 'should return true', ->
        oneOf(true).and(false).and(false).test().should.be.true

  context 'called multiple times', ->
    it 'should reset conditions after test', ->
      oneOf(true).and(true).test().should.be.false
      oneOf(true).and(false).test().should.be.true

  context '.reset', ->
    it 'should reset conditions', ->
      oneOf(true).and(true)
      oneOf.reset()
      oneOf(true).and(false).test().should.be.true

