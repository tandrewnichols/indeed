allOf = require('./../lib/allOf')

describe 'allOf', ->
  it 'should return an object with and', ->
    allOf(true).should.be.an.Object
    allOf(true).and.should.be.a.Function
    allOf(true).test.should.be.a.Function
    allOf.reset.should.be.a.Function

  describe '.and', ->
    context 'called with all true', ->
      it 'should return true', ->
        allOf(true).and(true).and(true).test().should.be.true
    context 'called with some true', ->
      it 'should return false', ->
        allOf(true).and(false).and(true).test().should.be.false
    context 'called with all false', ->
      it 'should return false', ->
        allOf(false).and(false).and(false).test().should.be.false

  context 'called multiple times', ->
    it 'should reset conditions after test', ->
      allOf(true).and(false).test().should.be.false
      allOf(true).and(true).test().should.be.true

  describe '.reset', ->
    it 'should reset conditions', ->
      allOf(true).and(false)
      allOf.reset()
      allOf(true).and(true).test().should.be.true

