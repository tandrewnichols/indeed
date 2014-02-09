expect = require('chai').expect
oneOf = require('./../lib/oneOf')

describe 'oneOf', ->
  it 'should return an object with and', ->
    expect(oneOf(true)).to.be.an.instanceOf(oneOf.OneOf)
    expect(oneOf(true).and).to.be.a('function')
    expect(oneOf(true).test).to.be.a('function')

  describe '#and', ->
    context 'called with all true', ->
      it 'should return false', ->
        expect(oneOf(true).and(true).test()).to.be.false
    context 'called with all false', ->
      it 'should return false', ->
        expect(oneOf(false).and(false).test()).to.be.false
    context 'called with two true and one false', ->
      it 'should return false', ->
        expect(oneOf(true).and(false).and(true).test()).to.be.false
    context 'called with one true', ->
      it 'should return true', ->
        expect(oneOf(true).and(false).and(false).test()).to.be.true

  describe '#And', ->
    it 'should delegate to indeed an and', ->
      expect(oneOf(true).and(false).And.indeed(true).and(true).test()).to.be.true

  describe '#Or', ->
    it 'should delegate to indeed with an or', ->
      expect(oneOf(false).and(false).Or.else(true).or(false).test()).to.be.true

  describe '#Xor', ->
    it 'should delegate to indeed with an xor', ->
      expect(oneOf(false).and(false).Xor.indeed(true).or(false).test()).to.be.true
