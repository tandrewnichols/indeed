noneOf = require('./../lib/noneOf')

describe 'noneOf', ->
  it 'should return an object with and', ->
    noneOf(true).should.be.an.Object
    noneOf(true).and.should.be.a.Function
    noneOf(true).test.should.be.a.Function
    noneOf.reset.should.be.a.Function

  describe '.and', ->
    context 'called with all true', ->
      it 'should return false', ->
        noneOf(true).and(true).and(true).test().should.be.false
    context 'called with some true', ->
      it 'should return false', ->
        noneOf(true).and(false).and(true).test().should.be.false
    context 'called with all false', ->
      it 'should return true', ->
        noneOf(false).and(false).and(false).test().should.be.true
  
  context 'called multiple times', ->
    it 'should reset conditions after test', ->
      noneOf(true).and(false).test().should.be.false
      noneOf(false).and(false).test().should.be.true

  describe '.reset', ->
    it 'should reset conditions', ->
      noneOf(true).and(false)
      noneOf.reset()
      noneOf(false).and(false).test().should.be.true
