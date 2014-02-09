expect = require('chai').expect
utils = require('./../lib/utils')
indeed = require('./../lib/indeed')

describe 'utils', ->
  describe '.delegate', ->
    beforeEach ->
      @indeed = utils.delegate(true, 'and')
    it 'should return an instance of Indeed', ->
      expect(@indeed).to.be.an.instanceOf(indeed.Indeed)

    it 'should initialize previous', ->
      expect(@indeed.previous).to.eql [
        val: true
        join: 'and'
      ]

    it 'should reset calls', ->
      expect(@indeed.calls).to.eql []
