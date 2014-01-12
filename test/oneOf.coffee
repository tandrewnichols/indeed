oneOf = require('./../lib/oneOf')

describe 'oneOf', ->
  it 'should return an object with and', ->
    oneOf(true).should.be.an.instanceOf(oneOf.OneOf)
    oneOf(true).and.should.be.a.Function
    oneOf(true).test.should.be.a.Function

  describe '#and', ->
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

  describe '#And', ->
    it 'should delegate to indeed an and', ->
      oneOf(true).and(false).And.indeed(true).and(true).test().should.be.true

  describe '#Or', ->
    it 'should delegate to indeed with an or', ->
      oneOf(false).and(false).Or.else(true).or(false).test().should.be.true

  describe '#Xor', ->
    it 'should delegate to indeed with an xor', ->
      oneOf(false).and(false).Xor.indeed(true).or(false).test().should.be.true
