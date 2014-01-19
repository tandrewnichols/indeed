indeed = require('./../lib/indeed')
_ = require('underscore')

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
    indeed(true).current.should.eql [
      val: true
      negate: undefined
      actual: true
    ]
    indeed.not(true).current.should.eql [
      val: true
      negate: true
      actual: true
    ]
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

  describe '#_chain', ->
    beforeEach ->
      @i = new indeed.Indeed(true)
    context 'when the method can be chained', ->
      it 'should set current', ->
        @i.calls = ['indeed']
        @i._chain('and', true, 'and')
        @i.current.pop().should.eql
          val: true
          actual: true
          join: 'and'
          negate: undefined

    context 'when the method cannot be chained', ->
      it 'should throw an error', ->
        i = @i
        i.calls = ['neither']
        ( ->
          i._chain('and', true, 'and')
        ).should.throw('IllegalMethodException: and cannot be called with neither')

  describe '#test', ->
    context 'no previous values', ->
      it 'should return basic values', ->
        indeed(true).test().should.be.true
        indeed(false).test().should.be.false

      it 'should return the value of current', ->
        result = indeed(true)
        result.test().should.be.true

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
        result.eval().should.be.true

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
        result.val().should.be.true

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
      indeed(true).And.indeed(false).current.pop().val.should.be.false
      indeed(true).And.indeed(false).test().should.be.false

    it 'should not allow nor', ->
      (->
        indeed(true).And.indeed(true).nor(false)
      ).should.throw('IllegalMethodException: nor cannot be called with indeed')
      
  describe '#also', ->
    it 'should reset current', ->
      indeed(true).And.also(false).current.pop().val.should.be.false
      indeed(true).And.also(false).test().should.be.false

    it 'should not allow nor', ->
      (->
        indeed(true).And.indeed(true).nor(false)
      ).should.throw('IllegalMethodException: nor cannot be called with indeed')

  describe '#else', ->
    it 'should reset current', ->
      indeed(true).Or.else(false).current.pop().val.should.be.false
      indeed(true).Or.else(false).test().should.be.true

    it 'should not allow nor', ->
      (->
        indeed(true).And.indeed(true).nor(false)
      ).should.throw('IllegalMethodException: nor cannot be called with indeed')

  describe '#not', ->
    it 'should reset current and negate the first element', ->
      cur = indeed(true).And.not(false).current.pop()
      cur.val.should.be.false
      cur.negate.should.be.true
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
      _(result.current).last().val.should.be.true
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
      last = _(result.current).last()
      last.val.should.be.false
      last.negate.should.be.true
      first = _(result.current).first()
      first.val.should.be.true
      result.test().should.be.true

  describe '#But', ->
    it 'should start a new condition set with &&', ->
      result = indeed(true).and(false).But.indeed(true).and(true)
      result.previous.length.should.eql(1)
      result.previous[0].should.eql
        val: false
        join: 'and'
      first = _(result.current).first()
      first.val.should.be.true
      last = _(result.current).last()
      last.val.should.be.true
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
      _(result.current).first().val.should.be.true
      last = _(result.current).last()
      last.val.should.be.false
      last.negate.should.be.true
      result.test().should.be.true

  describe '#Or', ->
    it 'should start a new condition set with ||', ->
      result = indeed(true).and(false).Or.else(true).and(true)
      result.previous.length.should.eql(1)
      result.previous[0].should.eql
        val: false
        join: 'or'
      _(result.current).first().val.should.be.true
      _(result.current).last().val.should.be.true
      result.test().should.be.true

  describe '#Not', ->
    it 'should negate a set', ->
      result = indeed(true).and(true).And.Not.also(true).and(false)
      _(result.current).first().val.should.be.true
      _(result.current).last().val.should.be.false
      result.previous[0].should.eql
        val: true
        join: 'and'
      result.groupNegate.should.be.true
      result.test().should.be.true

    it 'should negate an or', ->
      result = indeed(true).and(false).Or.Not.also(true).and(false)
      _(result.current).first().val.should.be.true
      _(result.current).last().val.should.be.false
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
      indeed(true).And.neither(true).nor(false).current.should.eql [
        val: true
        negate: true
        actual: true
      ,
        val: false
        actual: false
        negate: true
        join: 'and'
      ]

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

  describe '#is', ->
    context 'with a string', ->
      it 'should be true with the same string', ->
        indeed('string').is('string').test().should.be.true

      it 'should be false with different strings', ->
        indeed('string').is('nope').test().should.be.false

    context 'with numbers', ->
      it 'should be true for the same number', ->
        indeed(2).is(2).test().should.be.true

      it 'should be false for different numbers', ->
        indeed(2).is(4).test().should.be.false

    context 'with an array', ->
      it 'should be true for reference equality', ->
        @arr = [1,2,3]
        indeed(@arr).is(@arr).test().should.be.true

      it 'should be false for comparison equality', ->
        indeed([1,2,3]).is([1,2,3]).test().should.be.false

    context 'with object literals', ->
      it 'should be true for reference equality', ->
        @obj = key: 'value'
        indeed(@obj).is(@obj).test().should.be.true

      it 'should be false for comparison equality', ->
        indeed(key: 'value').is(key: 'value').test().should.be.false

    context 'with new-able objects', ->
      it 'should be true for reference equality', ->
        @d = new Date()
        indeed(@d).is(@d).test().should.be.true

      it 'should be false for comparison equality', ->
        indeed(new Date(2000, 9, 9)).is(new Date(2000, 9, 9)).test().should.be.false

  describe '#equal', ->
    context 'with a string', ->
      it 'should be true with the same string', ->
        indeed('string').equals('string').test().should.be.true

      it 'should be false with different strings', ->
        indeed('string').equals('nope').test().should.be.false

    context 'with numbers', ->
      it 'should be true for the same number', ->
        indeed(2).equals(2).test().should.be.true

      it 'should be false for different numbers', ->
        indeed(2).equals(4).test().should.be.false

    context 'with an array', ->
      it 'should be true for reference equality', ->
        @arr = [1,2,3]
        indeed(@arr).equals(@arr).test().should.be.true

      it 'should be true for comparison equality', ->
        indeed([1,2,3]).equals([1,2,3]).test().should.be.true

      it 'should be false for different arrays', ->
        indeed([1,2,3]).equals([4,5,6]).test().should.be.false

    context 'with object literals', ->
      it 'should be true for reference equality', ->
        @obj = key: 'value'
        indeed(@obj).equals(@obj).test().should.be.true

      it 'should be true for comparison equality', ->
        indeed(key: 'value').equals(key: 'value').test().should.be.true

      it 'should  be false for differnt objects', ->
        indeed(key: 'value').equals(hello: 'world').test().should.be.false

    context 'with new-able objects', ->
      it 'should be true for reference equality', ->
        @d = new Date()
        indeed(@d).equals(@d).test().should.be.true

      it 'should be true for comparison equality', ->
        indeed(new Date(2000, 9, 9)).equals(new Date(2000, 9, 9)).test().should.be.true
        
      it 'should be false for different objects', ->
        indeed(new Date(2000, 9, 9)).equals(new Date(1999, 3, 8)).test().should.be.false

  describe '#isA', ->
    it 'should return true if typeof matches', ->
      indeed('string').isA('string').test().should.be.true
      indeed(foo: 'bar').isA('object').test().should.be.true
