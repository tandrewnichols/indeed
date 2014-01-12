both = require('./../lib/both')

describe 'both', ->
  it 'should return an object with and', ->
    both(true).should.be.an.Object
    both(true).and.should.be.a.Function

  describe '#and', ->
    context 'both true', ->
      it 'should return true', ->
        both(true).and(true).test().should.be.true
    context 'one true', ->
      it 'should return false', ->
        both(true).and(false).test().should.be.false
    context 'both false', ->
      it 'should return false', ->
        both(false).and(false).test().should.be.false

    context 'called multiple times', ->
      ( ->
        both(true).and(true).and(true)
      ).should.throw('IllegalMethodException: and cannot be called with both/and')

  describe '#And', ->
    it 'should delegate to indeed an and', ->
      both(true).and(true).And.indeed(true).and(true).test().should.be.true

  describe '#Or', ->
    it 'should delegate to indeed with an or', ->
      both(true).and(false).Or.else(true).or(false).test().should.be.true

  describe '#Xor', ->
    it 'should delegate to indeed with an xor', ->
      both(true).and(false).Xor.indeed(true).or(false).test().should.be.true
