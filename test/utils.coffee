utils = require('./../lib/utils')
indeed = require('./../lib/indeed')

describe 'utils', ->
  describe '.makeGlobal', ->
    it 'should assign helpers to global', ->
      utils.makeGlobal()
      indeed.should.be.a.Function
      neither.should.be.a.Function
      either.should.be.a.Function
      both.should.be.a.Function
      noneOf.should.be.a.Function
      allOf.should.be.a.Function
      anyOf.should.be.a.Function
      oneOf.should.be.a.Function
      nOf.should.be.a.Function

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
