expect = require('chai').expect
either = require('./../lib/either')

describe 'either', ->
  it 'should return an object with or', ->
    expect(either(true)).to.be.an.instanceOf(either.Either)
    expect(either(true).or).to.be.a('function')
    expect(either(true).test).to.be.a('function')

  describe 'or', ->
    context 'both true', ->
      it 'should return true', ->
        expect(either(true).or(true).test()).to.be.true
    context 'the first true', ->
      it 'should return true', ->
        expect(either(true).or(false).test()).to.be.true
    context 'the second true', ->
      it 'should return true', ->
        expect(either(false).or(true).test()).to.be.true
    context 'both false', ->
      it 'should return false', ->
        expect(either(false).or(false).test()).to.be.false

    context 'called multiple times', ->
      expect(( ->
        either(true).or(true).or(true)
      )).to.throw('IllegalMethodException: or cannot be called with either/or')

  describe '#And', ->
    it 'should delegate to indeed an and', ->
      expect(either(true).or(false).And.indeed(true).and(true).test()).to.be.true

  describe '#Or', ->
    it 'should delegate to indeed with an or', ->
      expect(either(true).or(false).Or.else(true).or(false).test()).to.be.true

  describe '#Xor', ->
    it 'should delegate to indeed with an xor', ->
      expect(either(true).or(false).Xor.indeed(true).or(false).test()).to.be.false
