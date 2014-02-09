expect = require('chai').expect
both = require('./../lib/both')

describe 'both', ->
  it 'should return an object with and', ->
    expect(both(true)).to.be.an.instanceOf(both.Both)
    expect(both(true).and).to.be.a('function')
    expect(both(true).test).to.be.a('function')

  describe '#and', ->
    context 'both true', ->
      it 'should return true', ->
        expect(both(true).and(true).test()).to.be.true
    context 'one true', ->
      it 'should return false', ->
        expect(both(true).and(false).test()).to.be.false
    context 'both false', ->
      it 'should return false', ->
        expect(both(false).and(false).test()).to.be.false

    context 'called multiple times', ->
      expect((->
        both(true).and(true).and(true)
      )).to.throw('IllegalMethodException: and cannot be called with both/and')

  describe '#And', ->
    it 'should delegate to indeed an and', ->
      expect(both(true).and(true).And.indeed(true).and(true).test()).to.be.true

  describe '#Or', ->
    it 'should delegate to indeed with an or', ->
      expect(both(true).and(false).Or.else(true).or(false).test()).to.be.true

  describe '#Xor', ->
    it 'should delegate to indeed with an xor', ->
      expect(both(true).and(false).Xor.indeed(true).or(false).test()).to.be.true
