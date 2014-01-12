utils = require('./../lib/utils')
indeed = require('./../lib/indeed')

describe 'utils', ->
  describe '.delegate', ->
    beforeEach ->
      @indeed = utils.delegate(true, 'and')
    it 'should return an instance of Indeed', ->
      @indeed.should.be.an.instanceOf(indeed.Indeed)

    it 'should initialize previous', ->
      @indeed.previous.should.eql [
        val: true
        join: 'and'
      ]

    it 'should reset calls', ->
      @indeed.calls.should.eql []
