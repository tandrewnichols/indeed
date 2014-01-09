indeed = require('./../lib/indeed')

describe 'indeed', ->
  it 'should return a function', ->
    indeed.should.be.a.Function
    indeed.not.should.be.a.Function
    indeed.Not.should.be.a.Function
  
  it 'should return an Object of type Indeed', ->
    indeed(true).should.be.an.instanceOf(indeed.Indeed)
    indeed.not(true).should.be.an.instanceOf(indeed.Indeed)
    indeed.Not(true).should.be.an.instanceOf(indeed.Indeed)

  it 'should initialize values', ->
    indeed(true).previous.should.eql([])
    indeed(true).allowed.should.eql(['and', 'andNot', 'or', 'orNot', 'butNot'])
    indeed(true).current.should.be.true
    indeed.not(true).current.should.be.false
    indeed.Not(true).current.should.be.true
    indeed.Not(true).groupNegate.should.be.true

  describe '#test', ->
    context 'no previous values', ->
      it 'should return basic values', ->
        indeed(true).test().should.be.true
        indeed(false).test().should.be.false

      it 'should return the value of current', ->
        result = indeed(true)
        result.test().should.eql(result.current)

      it 'should apply groupNegate', ->
        result = indeed(true)
        result.groupNegate = true
        result.test().should.be.false

    #context 'with previous values', ->
      #it 'should join all the previous values correctly', ->
        #result = indeed(true)
        #result.previous = [
            #val: true
            #join: 'and'
          #,
            #val: false
            #join: 'or'
        #]
        #result.test().should.be.true

  #describe '_run', ->
    #beforeEach ->
      #@i = new indeed.Indeed(true)
    #context 'when this.allowed is empty', ->
      #it 'should set current, lastCall, and this.allowed', ->
        #@i.allowed = ['foobaby']
        #@i._run('foobaby', true, 'and')
        #@i.current.should.be.true
        #@i.lastCall.should.eql('foobaby')

    #context 'when name is in this.allowed', ->
      #it 'should set current', ->
        #@i.allowed = ['foobaby']
        #@i._run('foobaby', true, 'and')
        #@i.current.should.be.true
        #@i.lastCall.should.eql('foobaby')

    #context 'when name is not in this.allowed', ->
      #it 'should throw an error', ->
        #i = @i
        #i.allowed = ['daddy smurf']
        #i.lastCall = 'baby smurf'
        #( ->
          #i._run('smurfette', true, 'or')
        #).should.throw('IllegalMethodException: baby smurf cannot be called with smurfette')

  #describe '#eval', ->
    #it 'should work just like test', ->
      #indeed(true).eval().should.be.true

  #describe '#val', ->
    #it 'should work just like test', ->
      #indeed(true).eval().should.be.true

  #describe '#and', ->
    #it 'should "and" the previous result', ->
      #indeed(true).and(true).test().should.be.true
      #indeed(true).and(false).test().should.be.false
      #indeed(false).and(false).test().should.be.false
      #indeed(false).and(true).test().should.be.false
      #indeed(true).and(true).and(true).test().should.be.true
      #indeed(true).and(true).and(false).test().should.be.false

  #describe '#or', ->
    #it 'should "or" the previous result', ->
      #indeed(true).or(true).test().should.be.true
      #indeed(true).or(false).test().should.be.true
      #indeed(false).or(true).test().should.be.true
      #indeed(false).or(false).test().should.be.false

  #describe '#andNot', ->
    #it 'should "and not" the previous result', ->
      #indeed(false).andNot(true).test().should.be.false

  #describe '#butNot', ->
    #it 'should "and not" the previous result', ->
      #indeed(false).butNot(true).test().should.be.false
      
  #describe '#orNot', ->
    #it 'should "or not" the previous result', ->
      #indeed(false).orNot(true).test().should.be.false

  #describe '#indeed', ->
    #it 'should reset current', ->
      #indeed(true).And.indeed(false).current.should.be.false
      #indeed(true).And.indeed(false).test().should.be.false
      
  #describe '#also', ->
    #it 'should reset current', ->
      #indeed(true).And.also(false).current.should.be.false
      #indeed(true).And.also(false).test().should.be.false

  #describe '#else', ->
    #it 'should reset current', ->
      #indeed(true).else(false).current.should.be.false
      #indeed(true).else(false).test().should.be.false

  #describe '#And', ->
    #it 'should start a new condition set with &&', ->
      #result = indeed(true).and(false).And.indeed(true).and(true)
      #result.previous.length.should.eql(1)
      #result.previous[0].should.eql
        #val: false
        #join: 'and'
      #result.current.should.be.true
      #result.test().should.be.false

    #it 'should work with multiple conditions', ->
      #result = indeed(true).and(true).And.indeed(true).and(true).And.indeed(false).or(true).And.indeed(true).butNot(false)
      #result.previous.length.should.eql(3)
      #result.previous[0].should.eql
        #val: true
        #join: 'and'
      #result.previous[1].should.eql
        #val: true
        #join: 'and'
      #result.previous[2].should.eql
        #val: true
        #join: 'and'
      #result.current.should.be.true
      #result.test().should.be.true


  #describe '#Or', ->
    #it 'should start a new condition set with ||', ->
      #result = indeed(true).and(false).Or.else(true).and(true)
      #result.previous.length.should.eql(1)
      #result.previous[0].should.eql
        #val: false
        #join: 'or'
      #result.current.should.be.true
      #result.test().should.be.true

  #describe '#Not', ->
    #it 'should negate a set', ->
      #result = indeed(true).and(true).And.Not.also(true).and(false)
      #result.current.should.be.false
      #result.previous[0].should.eql
        #val: true
        #join: 'and'
      #result.groupNegate.should.be.true
      #result.test().should.be.true

    #it 'should negate an or', ->
      #result = indeed(true).and(false).Or.Not.also(true).and(false)
      #result.current.should.be.false
      #result.previous[0].should.eql
        #val: false
        #join: 'or'
      #result.groupNegate.should.be.true
      #result.test().should.be.true

  #describe '#Xor', ->
    #it 'should start a new condition set with ^', ->
      #indeed(true).and(true).Xor.indeed(true).and(true).test().should.be.false

  #describe '#neither', ->
    #it 'should start a new condition where both parts are negated', ->
      #result = indeed(true).and(true).And.neither(true).nor(false)
      #result.previous.length.should.eql(1)
      #result.previous[0].should.eql
        #val: true
        #join: 'and'
      #result.test().should.be.false

    #it 'should allow nor', ->
      #indeed(true).And.neither(true).allowed.should.eql ['nor']
      #( ->
        #indeed(true).And.neither(true).or(false)
      #).should.throw('IllegalMethodException: neither cannot be called with or')

  #describe '#either', ->
    #it 'should work like indeed/or', ->
      #indeed(true).And.either(true).or(false).test().should.be.true

  #describe '#both', ->
    #it 'should work like indeed/or', ->
      #indeed(true).And.both(true).and(false).test().should.be.false

