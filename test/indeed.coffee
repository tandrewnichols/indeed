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
    indeed(true).chain.should.eql('indeed')
    indeed(true).current.should.be.true
    indeed.not(true).current.should.be.false
    indeed.Not(true).current.should.be.true
    indeed.Not(true).groupNegate.should.be.true

  it 'should allow and, andNot, or, orNot, and butNot', ->
    (->
      indeed(true).and(true)
    ).should.not.throw()
    (->
      indeed(true).andNot(true)
    ).should.not.throw()
    (->
      indeed(true).or(true)
    ).should.not.throw()
    (->
      indeed(true).orNot(true)
    ).should.not.throw()
    (->
      indeed(true).butNot(true)
    ).should.not.throw()

  describe '#_run', ->
    beforeEach ->
      @i = new indeed.Indeed(true)
    context 'when the method can be chained', ->
      it 'should set current', ->
        @i.chain = 'indeed'
        @i._run('and', true, 'and')
        @i.current.should.be.true

    context 'when the method cannot be chained', ->
      it 'should throw an error', ->
        i = @i
        i.chain = 'neither'
        ( ->
          i._run('and', true, 'and')
        ).should.throw('IllegalMethodException: neither cannot be called with and')

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

    context 'with previous values', ->
      it 'should join all the previous values correctly', ->
        result = indeed(true)
        result.previous = [
            val: true
            join: 'and'
          ,
            val: false
            join: 'or'
        ]
        result.test().should.be.true

  describe '#eval', ->
    context 'no previous values', ->
      it 'should return basic values', ->
        indeed(true).eval().should.be.true
        indeed(false).eval().should.be.false

      it 'should return the value of current', ->
        result = indeed(true)
        result.eval().should.eql(result.current)

      it 'should apply groupNegate', ->
        result = indeed(true)
        result.groupNegate = true
        result.eval().should.be.false

    context 'with previous values', ->
      it 'should join all the previous values correctly', ->
        result = indeed(true)
        result.previous = [
            val: true
            join: 'and'
          ,
            val: false
            join: 'or'
        ]
        result.eval().should.be.true

  describe '#val', ->
    context 'no previous values', ->
      it 'should return basic values', ->
        indeed(true).val().should.be.true
        indeed(false).val().should.be.false

      it 'should return the value of current', ->
        result = indeed(true)
        result.val().should.eql(result.current)

      it 'should apply groupNegate', ->
        result = indeed(true)
        result.groupNegate = true
        result.val().should.be.false

    context 'with previous values', ->
      it 'should join all the previous values correctly', ->
        result = indeed(true)
        result.previous = [
            val: true
            join: 'and'
          ,
            val: false
            join: 'or'
        ]
        result.val().should.be.true

  describe '#and', ->
    it 'should "and" the previous result', ->
      indeed(true).and(true).test().should.be.true
      indeed(true).and(false).test().should.be.false
      indeed(false).and(false).test().should.be.false
      indeed(false).and(true).test().should.be.false
      indeed(true).and(true).and(true).test().should.be.true
      indeed(true).and(true).and(false).test().should.be.false

    it 'should allow and, andNot, or, orNot, and butNot', ->
      (->
        indeed(true).and(true).and(true)
      ).should.not.throw()
      (->
        indeed(true).and(true).andNot(true)
      ).should.not.throw()
      (->
        indeed(true).and(true).or(true)
      ).should.not.throw()
      (->
        indeed(true).and(true).orNot(true)
      ).should.not.throw()
      (->
        indeed(true).and(true).butNot(true)
      ).should.not.throw()
    
    it 'should not allow anything after both', ->
      (->
        indeed(true).And.both(true).and(true).and(true)
      ).should.throw('IllegalMethodException: both/and cannot be called with and')
      (->
        indeed(true).And.both(true).and(true).or(true)
      ).should.throw('IllegalMethodException: both/and cannot be called with or')

  describe '#or', ->
    it 'should "or" the previous result', ->
      indeed(true).or(true).test().should.be.true
      indeed(true).or(false).test().should.be.true
      indeed(false).or(true).test().should.be.true
      indeed(false).or(false).test().should.be.false

    it 'should allow and, andNot, or, orNot, and butNot', ->
      (->
        indeed(true).or(true).and(true)
      ).should.not.throw()
      (->
        indeed(true).or(true).andNot(true)
      ).should.not.throw()
      (->
        indeed(true).or(true).or(true)
      ).should.not.throw()
      (->
        indeed(true).or(true).orNot(true)
      ).should.not.throw()
      (->
        indeed(true).or(true).butNot(true)
      ).should.not.throw()

    it 'should not allow anything after either', ->
      (->
        indeed(true).And.either(true).or(true).and(true)
      ).should.throw('IllegalMethodException: either/or cannot be called with and')

  describe '#andNot', ->
    it 'should "and not" the previous result', ->
      indeed(false).andNot(true).test().should.be.false

  describe '#butNot', ->
    it 'should "and not" the previous result', ->
      indeed(false).butNot(true).test().should.be.false
      
  describe '#orNot', ->
    it 'should "or not" the previous result', ->
      indeed(false).orNot(true).test().should.be.false

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

