either = require('./../lib/either')

describe 'either', ->
  it 'should return an object with or', ->
    either(true).should.be.an.Object
    either(true).or.should.be.a.Function

  describe 'or', ->
    context 'both true', ->
      it 'should return true', ->
        either(true).or(true).test().should.be.true
    context 'the first true', ->
      it 'should return true', ->
        either(true).or(false).test().should.be.true
    context 'the second true', ->
      it 'should return true', ->
        either(false).or(true).test().should.be.true
    context 'both false', ->
      it 'should return false', ->
        either(false).or(false).test().should.be.false

    context 'called multiple times', ->
      ( ->
        either(true).or(true).or(true)
      ).should.throw('IllegalMethodException: or cannot be called with either/or')

  describe '#And', ->
    it 'should delegate to indeed an and', ->
      either(true).or(false).And.indeed(true).and(true).test().should.be.true

  describe '#Or', ->
    it 'should delegate to indeed with an or', ->
      either(true).or(false).Or.else(true).or(false).test().should.be.true

  describe '#Xor', ->
    it 'should delegate to indeed with an xor', ->
      either(true).or(false).Xor.indeed(true).or(false).test().should.be.false
