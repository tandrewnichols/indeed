expect = require('chai').expect
neither = require('./../lib/neither')

describe 'neither', ->
  it 'should accept a boolean and return an object with nor', ->
    expect(neither(true)).to.be.an.instanceOf(neither.Neither)
    expect(neither(true).nor).to.be.a('function')
    expect(neither(true).test).to.be.a('function')

  describe 'nor', ->
    context 'both are false', ->
      it 'should return true', ->
        expect(neither(false).nor(false).test()).to.be.true
    context 'one is false', ->
      it 'should return false', ->
        expect(neither(false).nor(true).test()).to.be.false
    context 'both are true', ->
      it 'should return false', ->
        expect(neither(true).nor(true).test()).to.be.false

    context 'called multiple times', ->
      expect(( ->
        neither(true).nor(true).nor(true)
      )).to.throw('IllegalMethodException: nor cannot be called with neither/nor')

  describe '#And', ->
    it 'should delegate to indeed an and', ->
      expect(neither(true).nor(false).And.indeed(true).and(true).test()).to.be.false

  describe '#Or', ->
    it 'should delegate to indeed with an or', ->
      expect(neither(true).nor(false).Or.else(true).or(false).test()).to.be.true

  describe '#Xor', ->
    it 'should delegate to indeed with an xor', ->
      expect(neither(true).nor(false).Xor.indeed(true).or(false).test()).to.be.true
