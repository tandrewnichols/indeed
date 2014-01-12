allOf = require('./../lib/allOf')

describe 'allOf', ->
  it 'should return an object with and', ->
    allOf(true).should.be.an.Object
    allOf(true).and.should.be.a.Function
    allOf(true).test.should.be.a.Function

  describe '#and', ->
    context 'called with all true', ->
      it 'should return true', ->
        allOf(true).and(true).and(true).test().should.be.true
    context 'called with some true', ->
      it 'should return false', ->
        allOf(true).and(false).and(true).test().should.be.false
    context 'called with all false', ->
      it 'should return false', ->
        allOf(false).and(false).and(false).test().should.be.false

  describe '#And', ->
    it 'should delegate to indeed an and', ->
      allOf(true).and(true).And.indeed(true).and(true).test().should.be.true

  describe '#Or', ->
    it 'should delegate to indeed with an or', ->
      allOf(true).and(false).Or.else(true).or(false).test().should.be.true

  describe '#Xor', ->
    it 'should delegate to indeed with an xor', ->
      allOf(true).and(false).Xor.indeed(true).or(false).test().should.be.true

  describe 'Not', ->
    it 'should negate the next group', ->
      allOf(true).and(true).And.Not.indeed(true).and(true).test().should.be.false
