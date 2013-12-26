nOf = require('./../lib/nOf')

describe 'nOf', ->
  beforeEach ->
    nOf.reset()

  it 'should return an object with and', ->
    nOf(true).should.be.an.Object
    nOf(true).and.should.be.a.Function
    nOf(true).test.should.be.a.Function
    nOf.reset.should.be.a.Function

  describe '.and', ->
    context 'with the right number of trues', ->
      it 'should return true', ->
        nOf(true).and(true).and(false).test(2).should.be.true
    context 'with the wrong number of trues', ->
      it 'should return false', ->
        nOf(true).and(false).and(false).test(2).should.be.false

  context 'called multiple times', ->
    it 'should reset conditions after test', ->
      nOf(true).and(false).test(2).should.be.false
      nOf(true).and(true).test(2).should.be.true

  describe '.reset', ->
    it 'should reset conditions', ->
      nOf(true).and(false)
      nOf.reset()
      nOf(true).and(true).test(2).should.be.true
