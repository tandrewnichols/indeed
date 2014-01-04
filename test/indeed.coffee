indeed = require('./../lib/indeed')

describe 'indeed', ->
  it 'should return a function', ->
    indeed.should.be.a.Function
    indeed.not.should.be.a.Function
  
  it 'should return an Object of type Indeed', ->
    indeed(true).should.be.an.instanceOf(indeed.Indeed)
    indeed.not(true).should.be.an.instanceOf(indeed.Indeed)

  it 'should have a test method', ->
    indeed(true).test.should.be.a.Function

  describe '#test', ->
    it 'should return true from true', ->
      indeed(true).test().should.be.true

    it 'should return false from false', ->
      indeed(false).test().should.be.false

    describe '.not', ->
      it 'should invert true', ->
        indeed.not(true).test().should.be.false

      it 'should invert false', ->
        indeed.not(false).test().should.be.true

    describe '.Not', ->
      it 'should invert a group', ->
        indeed.Not(true).and(false).test().should.be.true

  describe '#eval', ->
    it 'should work just like test', ->
      indeed(true).eval().should.be.true

  describe '#val', ->
    it 'should work just like test', ->
      indeed(true).eval().should.be.true

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

  describe '#andNot', ->
    it 'should "and not" the previous result', ->
      indeed(false).andNot(true).test().should.be.false
      
  describe '#orNot', ->
    it 'should "or not" the previous result', ->
      indeed(false).orNot(true).test().should.be.false

  describe '#butAlso', ->
    it 'should start a new set of conditions joined with and', ->
      indeed(true).and(true).butAlso(false).or(true).test().should.be.true
      indeed(true).and(true).butAlso(false).or(true).butAlso(true).and(true).test().should.be.true

  describe '#butAlsoNot', ->
    it 'should start a new set of conditions and negate that set', ->
      indeed(true).and(true).butAlsoNot(true).and(false).test().should.be.true

  #describe '#Or', ->
    #it 'should start a new set of conditions joined with or', ->
