n = require('./../lib/nOf')

describe 'nOf', ->
  it 'should return an object with and', ->
    n(2).should.be.an.instanceOf(n.NOf)
    n(2).and.should.be.a.Function
    n(2).test.should.be.a.Function
    n(2).of.should.be.a.Function

  describe '#and', ->
    context 'with the right number of trues', ->
      it 'should return true', ->
        n(2).of(true).and(true).and(false).test().should.be.true
    context 'with the wrong number of trues', ->
      it 'should return false', ->
        n(2).of(true).and(false).and(false).test().should.be.false

    context 'called multiple times', ->
      ( ->
        n(2).of(true).of(false)
      ).should.throw('IllegalMethodException: of cannot be called with of/and')

  describe '#And', ->
    it 'should delegate to indeed an and', ->
      n(1).of(true).and(true).And.indeed(true).and(true).test().should.be.false

  describe '#Or', ->
    it 'should delegate to indeed with an or', ->
      n(1).of(true).and(true).Or.else(true).or(false).test().should.be.true

  describe '#Xor', ->
    it 'should delegate to indeed with an xor', ->
      n(1).of(true).and(true).Xor.indeed(true).or(false).test().should.be.true
