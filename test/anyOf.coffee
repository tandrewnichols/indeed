expect = require('chai').expect
anyOf = require('./../lib/anyOf')

describe 'anyOf', ->
  it 'should return an object with and', ->
    expect(anyOf(true)).to.be.an.instanceOf(anyOf.AnyOf)
    expect(anyOf(true).and).to.be.a('function')
    expect(anyOf(true).test).to.be.a('function')

  describe '#and', ->
    context 'none true', ->
      it 'should return false', ->
        expect(anyOf(false).and(false).test()).to.be.false
    context 'one true', ->
      it 'should return true', ->
        expect(anyOf(true).and(false).test()).to.be.true
    context 'all true', ->
      it 'should return true', ->
        expect(anyOf(true).and(true).test()).to.be.true

  describe '#And', ->
    it 'should delegate to indeed with and', ->
      expect(anyOf(true).and(false).And.also(true).or(false).test()).to.be.true

  describe '#Or', ->
    it 'should delegate to indeed with or', ->
      expect(anyOf(true).and(false).Or.also(true).or(false).test()).to.be.true

  describe '#Xor', ->
    it 'should delegate to indeed with xor', ->
      expect(anyOf(true).and(false).Xor.also(true).or(false).test()).to.be.false
