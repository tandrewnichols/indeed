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
    indeed(true).calls.should.eql(['indeed'])
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
        @i.calls = ['indeed']
        @i._run('and', true, 'and')
        @i.current.should.be.true

    context 'when the method cannot be chained', ->
      it 'should throw an error', ->
        i = @i
        i.calls = ['neither']
        ( ->
          i._run('and', true, 'and')
        ).should.throw('IllegalMethodException: and cannot be called with neither')

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
      ).should.throw('IllegalMethodException: and cannot be called with both/and')
      (->
        indeed(true).And.both(true).and(true).or(true)
      ).should.throw('IllegalMethodException: or cannot be called with both/and')

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
      ).should.throw('IllegalMethodException: and cannot be called with either/or')
      (->
        indeed(true).And.either(true).or(true).or(true)
      ).should.throw('IllegalMethodException: or cannot be called with either/or')

  describe '#andNot', ->
    it 'should "and not" the previous result', ->
      indeed(false).andNot(true).test().should.be.false

  describe '#butNot', ->
    it 'should "and not" the previous result', ->
      indeed(false).butNot(true).test().should.be.false
      
  describe '#orNot', ->
    it 'should "or not" the previous result', ->
      indeed(false).orNot(true).test().should.be.false

  describe '#indeed', ->
    it 'should reset current', ->
      indeed(true).And.indeed(false).current.should.be.false
      indeed(true).And.indeed(false).test().should.be.false

    it 'should not allow nor', ->
      (->
        indeed(true).And.indeed(true).nor(false)
      ).should.throw('IllegalMethodException: nor cannot be called with indeed')
      
  describe '#also', ->
    it 'should reset current', ->
      indeed(true).And.also(false).current.should.be.false
      indeed(true).And.also(false).test().should.be.false

    it 'should not allow nor', ->
      (->
        indeed(true).And.indeed(true).nor(false)
      ).should.throw('IllegalMethodException: nor cannot be called with indeed')

  describe '#else', ->
    it 'should reset current', ->
      indeed(true).Or.else(false).current.should.be.false
      indeed(true).Or.else(false).test().should.be.true

    it 'should not allow nor', ->
      (->
        indeed(true).And.indeed(true).nor(false)
      ).should.throw('IllegalMethodException: nor cannot be called with indeed')

  describe '#And', ->
    it 'should start a new condition set with &&', ->
      result = indeed(true).and(false).And.indeed(true).and(true)
      result.previous.length.should.eql(1)
      result.previous[0].should.eql
        val: false
        join: 'and'
      result.current.should.be.true
      result.test().should.be.false

    it 'should work with multiple conditions', ->
      result = indeed(true).and(true).And.indeed(true).and(true).And.indeed(false).or(true).And.indeed(true).butNot(false)
      result.previous.length.should.eql(3)
      result.previous[0].should.eql
        val: true
        join: 'and'
      result.previous[1].should.eql
        val: true
        join: 'and'
      result.previous[2].should.eql
        val: true
        join: 'and'
      result.current.should.be.true
      result.test().should.be.true


  describe '#Or', ->
    it 'should start a new condition set with ||', ->
      result = indeed(true).and(false).Or.else(true).and(true)
      result.previous.length.should.eql(1)
      result.previous[0].should.eql
        val: false
        join: 'or'
      result.current.should.be.true
      result.test().should.be.true

  describe '#Not', ->
    it 'should negate a set', ->
      result = indeed(true).and(true).And.Not.also(true).and(false)
      result.current.should.be.false
      result.previous[0].should.eql
        val: true
        join: 'and'
      result.groupNegate.should.be.true
      result.test().should.be.true

    it 'should negate an or', ->
      result = indeed(true).and(false).Or.Not.also(true).and(false)
      result.current.should.be.false
      result.previous[0].should.eql
        val: false
        join: 'or'
      result.groupNegate.should.be.true
      result.test().should.be.true

  describe '#Xor', ->
    it 'should start a new condition set with ^', ->
      indeed(true).and(true).Xor.indeed(true).and(true).test().should.be.false

  describe '#neither', ->
    it 'should start a new condition where both parts are negated', ->
      result = indeed(true).and(true).And.neither(true).nor(false)
      result.previous.length.should.eql(1)
      result.previous[0].should.eql
        val: true
        join: 'and'
      result.test().should.be.false

    it 'should allow nor', ->
      ( ->
        indeed(true).And.neither(true).or(false)
      ).should.throw('IllegalMethodException: or cannot be called with neither')
      
      ( ->
        indeed(true).And.neither(true).and(false)
      ).should.throw('IllegalMethodException: and cannot be called with neither')

      ( ->
        indeed(true).And.neither(true).nor(false)
      ).should.not.throw()

  describe '#nor', ->
    it 'should and the negated condition', ->
      indeed(true).And.neither(true).nor(false).current.should.be.false

    it 'should not be chainable with anything', ->
      ( ->
        indeed(true).And.neither(true).nor(false).and(true)
      ).should.throw('IllegalMethodException: and cannot be called with neither/nor')

      ( ->
        indeed(true).And.neither(true).nor(false).indeed(true)
      ).should.throw('IllegalMethodException: indeed cannot be called with neither/nor')

  describe '#either', ->
    it 'should start a new condition', ->
      indeed(true).And.either(true).or(false).test().should.be.true

    it 'should allow or', ->
      ( ->
        indeed(true).And.either(true).and(true)
      ).should.throw('IllegalMethodException: and cannot be called with either')

      ( ->
        indeed(true).And.either(true).nor(true)
      ).should.throw('IllegalMethodException: nor cannot be called with either')

      ( ->
        indeed(true).And.either(true).or(true)
      ).should.not.throw()

      ( ->
        indeed(true).And.either(true).either(true)
      ).should.throw('IllegalMethodException: either cannot be called with either')

  describe '#both', ->
    it 'should start a new condition', ->
      indeed(true).And.both(true).and(false).test().should.be.false

    it 'should only allow and (once)', ->
      ( ->
        indeed(true).And.both(true).and(true)
      ).should.not.throw()

      ( ->
        indeed(true).And.both(true).or(true)
      ).should.throw('IllegalMethodException: or cannot be called with both')

      ( ->
        indeed(true).And.both(true).and(true).and(true)
      ).should.throw('IllegalMethodException: and cannot be called with both/and')

  describe '#allOf', ->
    it 'should and all conditions', ->
      indeed(true).And.allOf(true).and(true).and(true).test().should.be.true
      indeed(true).And.allOf(true).and(true).and(true).and(false).test().should.be.false

    it 'should only allow and', ->
      ( ->
        indeed(true).And.allOf(true).and(true).or(true)
      ).should.throw('IllegalMethodException: or cannot be called with allOf')

      ( ->
        indeed(true).And.allOf(true).and(true).both(false)
      ).should.throw('IllegalMethodException: both cannot be called with allOf')

  describe '#oneOf', ->
    it 'should return true when exactly one condition is true', ->
     indeed(true).And.oneOf(true).and(false).and(false).test().should.be.true

    it 'should only allow and', ->
      ( ->
        indeed(true).And.oneOf(true).and(false).or(true)
      ).should.throw('IllegalMethodException: or cannot be called with oneOf')

      ( ->
        indeed(true).And.oneOf(true).and(false).else(true)
      ).should.throw('IllegalMethodException: else cannot be called with oneOf')

  describe '#anyOf', ->
    it 'should return true when any one condition is true', ->
      indeed(true).And.anyOf(true).and(false).and(true).test().should.be.true
      indeed(true).And.anyOf(true).and(false).and(false).test().should.be.true
      indeed(true).And.anyOf(false).and(true).and(false).test().should.be.true
      indeed(true).And.anyOf(false).and(false).and(false).test().should.be.false

    it 'should only allow and', ->
      ( ->
        indeed(true).And.anyOf(true).and(false).or(true)
      ).should.throw('IllegalMethodException: or cannot be called with anyOf')

      ( ->
        indeed(true).And.anyOf(true).and(false).both(true)
      ).should.throw('IllegalMethodException: both cannot be called with anyOf')

  describe '#noneOf', ->
    it 'should return true only when all conditions are false', ->
      indeed(true).And.noneOf(false).and(false).and(false).test().should.be.true
      indeed(true).And.noneOf(true).and(false).and(false).test().should.be.false

    it 'should only allow and', ->
      ( ->
        indeed(true).And.noneOf(true).and(false).or(true)
      ).should.throw('IllegalMethodException: or cannot be called with noneOf')

      ( ->
        indeed(true).And.noneOf(true).and(false).anyOf(false)
      ).should.throw('IllegalMethodException: anyOf cannot be called with noneOf')
