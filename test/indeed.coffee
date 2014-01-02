indeed = require('./../lib/indeed')

describe 'indeed', ->
  it 'should return a function', ->
    indeed.should.be.a.Function

  describe '.indeed', ->
    it 'should return an Object of type Indeed', ->
      indeed(true).constructor.name.should.eql("Indeed")

    it 'should have an array of conditions', ->
      indeed(true).test.should.be.a.Function
      indeed(true).test().should.be.true

  describe '#and', ->
    it 'should "and" the previous result', ->
      indeed(true).and(true).test().should.be.true
      indeed(true).and(false).test().should.be.false
      indeed(false).and(false).test().should.be.false
      indeed(false).and(true).test().should.be.false
      indeed(true).and(true).and(true).test().should.be.true
      indeed(true).and(true).and(false).test().should.be.false

  describe '#or', ->
    it 'should "or" the previous result', ->
      indeed(true).or(true).test().should.be.true
      indeed(true).or(false).test().should.be.true
      indeed(false).or(true).test().should.be.true
      indeed(false).or(false).test().should.be.false

  describe '#butNot', ->
    it 'should "and" the negative', ->
      indeed(true).butNot(false).test().should.be.true
      indeed(true).butNot(true).test().should.be.false
      indeed(false).butNot(true).test().should.be.false
      indeed(false).butNot(false).test().should.be.false

  describe '#andNot', ->
    it 'should "and" the negative', ->
      indeed(true).andNot(false).test().should.be.true
      indeed(true).andNot(true).test().should.be.false
      indeed(false).andNot(true).test().should.be.false
      indeed(false).andNot(false).test().should.be.false
