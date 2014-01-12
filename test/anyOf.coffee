anyOf = require('./../lib/anyOf')

describe 'anyOf', ->
  it 'should return an object with and', ->
    anyOf(true).should.be.an.instanceOf(anyOf.AnyOf)
    anyOf(true).and.should.be.a.Function
    anyOf(true).test.should.be.a.Function

  describe '#and', ->
    context 'none true', ->
      it 'should return false', ->
        anyOf(false).and(false).test().should.be.false
    context 'one true', ->
      it 'should return true', ->
        anyOf(true).and(false).test().should.be.true
    context 'all true', ->
      it 'should return true', ->
        anyOf(true).and(true).test().should.be.true

  describe '#And', ->
    it 'should delegate to indeed with and', ->
      anyOf(true).and(false).And.also(true).or(false).test().should.be.true

  describe '#Or', ->
    it 'should delegate to indeed with or', ->
      anyOf(true).and(false).Or.also(true).or(false).test().should.be.true

  describe '#Xor', ->
    it 'should delegate to indeed with xor', ->
      anyOf(true).and(false).Xor.also(true).or(false).test().should.be.false
