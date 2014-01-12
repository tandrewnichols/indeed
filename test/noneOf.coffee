noneOf = require('./../lib/noneOf')

describe 'noneOf', ->
  it 'should return an object with and', ->
    noneOf(true).should.be.an.instanceOf(noneOf.NoneOf)
    noneOf(true).and.should.be.a.Function
    noneOf(true).test.should.be.a.Function

  describe '#and', ->
    context 'called with all true', ->
      it 'should return false', ->
        noneOf(true).and(true).and(true).test().should.be.false
    context 'called with some true', ->
      it 'should return false', ->
        noneOf(true).and(false).and(true).test().should.be.false
    context 'called with all false', ->
      it 'should return true', ->
        noneOf(false).and(false).and(false).test().should.be.true

  describe '#And', ->
    it 'should delegate to indeed an and', ->
      noneOf(false).and(false).And.indeed(true).and(false).test().should.be.false

  describe '#Or', ->
    it 'should delegate to indeed with an or', ->
      noneOf(true).and(false).Or.else(true).or(false).test().should.be.true

  describe '#Xor', ->
    it 'should delegate to indeed with an xor', ->
      noneOf(true).and(false).Xor.indeed(true).or(false).test().should.be.true
