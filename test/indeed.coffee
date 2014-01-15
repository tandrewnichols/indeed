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
    indeed(true).current.value.should.be.true
    indeed.not(true).current.value.should.be.false
    indeed.Not(true).current.value.should.be.true
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

  describe '#_exists', ->
    beforeEach ->
      @i = new indeed.Indeed(true)
    context 'when the method can be chained', ->
      it 'should set current', ->
        @i.calls = ['indeed']
        @i._exists('and', true, 'and')
        @i.current.value.should.be.true

    context 'when the method cannot be chained', ->
      it 'should throw an error', ->
        i = @i
        i.calls = ['neither']
        ( ->
          i._exists('and', true, 'and')
        ).should.throw('IllegalMethodException: and cannot be called with neither')

  describe '#_compare', ->
    context 'with a string', ->
      it 'should be true with the same string', ->
        i = indeed('string')
        i._compare('is', 'string')
        i.current.should.eql
          value: true
          actual: 'string'

      it 'should be false with different strings', ->
        i = indeed('string')
        i._compare('is', 'nope')
        i.current.should.eql
          value: false
          actual: 'string'

    context 'with numbers', ->
      it 'should be true for the same number', ->
        i = indeed(2)
        i._compare('is', 2)
        i.current.should.eql
          value: true
          actual: 2

      it 'should be false for different numbers', ->
        i = indeed(2)
        i._compare('is', 4)
        i.current.should.eql
          value: false
          actual: 2

    context 'with an array', ->
      it 'should be true for reference equality', ->
        @arr = [1,2,3]
        i = indeed(@arr)
        i._compare('is', @arr)
        i.current.should.eql
          value: true
          actual: @arr

      it 'should be false for comparison equality', ->
        i = indeed([1,2,3])
        i._compare('is', [1,2,3])
        i.current.should.eql
          value: false
          actual: [1,2,3]

    context 'with object literals', ->
      it 'should be true for reference equality', ->
        @obj = key: 'value'
        i = indeed(@obj)
        i._compare('is', @obj)
        i.current.should.eql
          value: true
          actual: @obj

      it 'should be false for comparison equality', ->
        i = indeed(key: 'value')
        i._compare('is', key: 'value')
        i.current.should.eql
          value: false
          actual:
            key: 'value'

    context 'with new-able objects', ->
      it 'should be true for reference equality', ->
        @d = new Date()
        i = indeed(@d)
        i._compare('is', @d)
        i.current.should.eql
          value: true
          actual: @d

      it 'should be false for comparison equality', ->
        i = indeed(new Date(2000, 9, 9))
        i._compare('is', new Date(2000, 9, 9))
        i.current.should.eql
          value: false
          actual: new Date(2000, 9, 9)

  describe '#test', ->
    context 'no previous values', ->
      it 'should return basic values', ->
        indeed(true).test().should.be.true
        indeed(false).test().should.be.false

      it 'should return the value of current', ->
        result = indeed(true)
        result.test().should.eql(result.current.value)

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
        result.eval().should.eql(result.current.value)

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
        result.val().should.eql(result.current.value)

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

  describe '#xor', ->
    it 'should "xor" the previous result', ->
      indeed(true).xor(false).test().should.be.true
      indeed(true).xor(true).test().should.be.false
      indeed(false).xor(false).test().should.be.false
      indeed(true).xor(false).xor(true).test().should.be.false

  describe '#indeed', ->
    it 'should reset current', ->
      indeed(true).And.indeed(false).current.value.should.be.false
      indeed(true).And.indeed(false).test().should.be.false

    it 'should not allow nor', ->
      (->
        indeed(true).And.indeed(true).nor(false)
      ).should.throw('IllegalMethodException: nor cannot be called with indeed')
      
  describe '#also', ->
    it 'should reset current', ->
      indeed(true).And.also(false).current.value.should.be.false
      indeed(true).And.also(false).test().should.be.false

    it 'should not allow nor', ->
      (->
        indeed(true).And.indeed(true).nor(false)
      ).should.throw('IllegalMethodException: nor cannot be called with indeed')

  describe '#else', ->
    it 'should reset current', ->
      indeed(true).Or.else(false).current.value.should.be.false
      indeed(true).Or.else(false).test().should.be.true

    it 'should not allow nor', ->
      (->
        indeed(true).And.indeed(true).nor(false)
      ).should.throw('IllegalMethodException: nor cannot be called with indeed')

  describe '#not', ->
    it 'should reset current and negate the first element', ->
      indeed(true).And.not(false).current.value.should.be.true
      indeed(true).And.not(false).test().should.be.true

    it 'should not allow nor', ->
      (->
        indeed(true).And.not(true).nor(false)
      ).should.throw('IllegalMethodException: nor cannot be called with not')

  describe '#And', ->
    it 'should start a new condition set with &&', ->
      result = indeed(true).and(false).And.indeed(true).and(true)
      result.previous.length.should.eql(1)
      result.previous[0].should.eql
        val: false
        join: 'and'
      result.current.value.should.be.true
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
      result.current.value.should.be.true
      result.test().should.be.true

  describe '#But', ->
    it 'should start a new condition set with &&', ->
      result = indeed(true).and(false).But.indeed(true).and(true)
      result.previous.length.should.eql(1)
      result.previous[0].should.eql
        val: false
        join: 'and'
      result.current.value.should.be.true
      result.test().should.be.false

    it 'should work with multiple conditions', ->
      result = indeed(true).and(true).But.indeed(true).and(true).But.indeed(false).or(true).But.indeed(true).butNot(false)
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
      result.current.value.should.be.true
      result.test().should.be.true

  describe '#Or', ->
    it 'should start a new condition set with ||', ->
      result = indeed(true).and(false).Or.else(true).and(true)
      result.previous.length.should.eql(1)
      result.previous[0].should.eql
        val: false
        join: 'or'
      result.current.value.should.be.true
      result.test().should.be.true

  describe '#Not', ->
    it 'should negate a set', ->
      result = indeed(true).and(true).And.Not.also(true).and(false)
      result.current.value.should.be.false
      result.previous[0].should.eql
        val: true
        join: 'and'
      result.groupNegate.should.be.true
      result.test().should.be.true

    it 'should negate an or', ->
      result = indeed(true).and(false).Or.Not.also(true).and(false)
      result.current.value.should.be.false
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
      indeed(true).And.neither(true).nor(false).current.value.should.be.false

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

    it 'should allow and (once)', ->
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

    it 'should allow and', ->
      ( ->
        indeed(true).And.allOf(true).and(true).or(true)
      ).should.throw('IllegalMethodException: or cannot be called with allOf')

      ( ->
        indeed(true).And.allOf(true).and(true).both(false)
      ).should.throw('IllegalMethodException: both cannot be called with allOf')

  describe '#oneOf', ->
    it 'should return true when exactly one condition is true', ->
     indeed(true).And.oneOf(true).and(false).and(false).test().should.be.true

    it 'should allow and', ->
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

    it 'should allow and', ->
      ( ->
        indeed(true).And.anyOf(true).and(false).or(true)
      ).should.throw('IllegalMethodException: or cannot be called with anyOf')

      ( ->
        indeed(true).And.anyOf(true).and(false).both(true)
      ).should.throw('IllegalMethodException: both cannot be called with anyOf')

  describe '#noneOf', ->
    it 'should return true when all conditions are false', ->
      indeed(true).And.noneOf(false).and(false).and(false).test().should.be.true
      indeed(true).And.noneOf(true).and(false).and(false).test().should.be.false

    it 'should allow and', ->
      ( ->
        indeed(true).And.noneOf(true).and(false).or(true)
      ).should.throw('IllegalMethodException: or cannot be called with noneOf')

      ( ->
        indeed(true).And.noneOf(true).and(false).anyOf(false)
      ).should.throw('IllegalMethodException: anyOf cannot be called with noneOf')

  #describe '#is', ->
    #it 'should compare it\'s value with the actual condition passed previous', ->
      #indeed('hello').is('hello')
