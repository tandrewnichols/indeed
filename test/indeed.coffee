expect = require('chai').expect
indeed = require('./../lib/indeed')
_ = require('underscore')

describe 'indeed', ->
  it 'should return a function', ->
    expect(indeed).to.be.a('function')
    expect(indeed.not).to.be.a('function')
    expect(indeed.Not).to.be.a('function')
  
  it 'should return an Object of type Indeed', ->
    expect(indeed(true)).to.be.an.instanceOf(indeed.Indeed)
    expect(indeed.not(true)).to.be.an.instanceOf(indeed.Indeed)
    expect(indeed.Not(true)).to.be.an.instanceOf(indeed.Indeed)

  it 'should initialize values', ->
    expect(indeed(true).previous).to.eql([])
    expect(indeed(true).calls).to.eql(['indeed'])
    expect(indeed(true).current).to.eql [
      val: true
      negate: undefined
      actual: true
    ]
    expect(indeed.not(true).current).to.eql [
      val: true
      negate: true
      actual: true
    ]
    expect(indeed.Not(true).groupNegate).to.be.true

  it 'should allow and, andNot, or, orNot, and butNot', ->
    expect((->
      indeed(true).and(true)
    )).to.not.throw()
    expect((->
      indeed(true).andNot(true)
    )).to.not.throw()
    expect((->
      indeed(true).or(true)
    )).to.not.throw()
    expect((->
      indeed(true).orNot(true)
    )).to.not.throw()
    expect((->
      indeed(true).butNot(true)
    )).to.not.throw()

  describe '#_chain', ->
    beforeEach ->
      @i = new indeed.Indeed(true)
    context 'when the method can be chained', ->
      it 'should set current', ->
        @i.calls = ['indeed']
        @i._chain('and', true, 'and')
        expect(@i.current.pop()).to.eql
          val: true
          actual: true
          join: 'and'
          negate: undefined

    context 'when the method cannot be chained', ->
      it 'should throw an error', ->
        i = @i
        i.calls = ['neither']
        expect(( ->
          i._chain('and', true, 'and')
        )).to.throw('IllegalMethodException: and cannot be called with neither')

  describe '#test', ->
    context 'no previous values', ->
      it 'should return basic values', ->
        expect(indeed(true).test()).to.be.true
        expect(indeed(false).test()).to.be.false

      it 'should return the value of current', ->
        result = indeed(true)
        expect(result.test()).to.be.true

      it 'should apply groupNegate', ->
        result = indeed(true)
        result.groupNegate = true
        expect(result.test()).to.be.false

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
        expect(result.test()).to.be.true

  describe '#eval', ->
    context 'no previous values', ->
      it 'should return basic values', ->
        expect(indeed(true).eval()).to.be.true
        expect(indeed(false).eval()).to.be.false

      it 'should return the value of current', ->
        result = indeed(true)
        expect(result.eval()).to.be.true

      it 'should apply groupNegate', ->
        result = indeed(true)
        result.groupNegate = true
        expect(result.eval()).to.be.false

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
        expect(result.eval()).to.be.true

  describe '#val', ->
    context 'no previous values', ->
      it 'should return basic values', ->
        expect(indeed(true).val()).to.be.true
        expect(indeed(false).val()).to.be.false

      it 'should return the value of current', ->
        result = indeed(true)
        expect(result.val()).to.be.true

      it 'should apply groupNegate', ->
        result = indeed(true)
        result.groupNegate = true
        expect(result.val()).to.be.false

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
        expect(result.val()).to.be.true

  describe '#and', ->
    it 'should "and" the previous result', ->
      expect(indeed(true).and(true).test()).to.be.true
      expect(indeed(true).and(false).test()).to.be.false
      expect(indeed(false).and(false).test()).to.be.false
      expect(indeed(false).and(true).test()).to.be.false
      expect(indeed(true).and(true).and(true).test()).to.be.true
      expect(indeed(true).and(true).and(false).test()).to.be.false

    it 'should allow and, andNot, or, orNot, and butNot', ->
      expect((->
        indeed(true).and(true).and(true)
      )).to.not.throw()
      expect((->
        indeed(true).and(true).andNot(true)
      )).to.not.throw()
      expect((->
        indeed(true).and(true).or(true)
      )).to.not.throw()
      expect((->
        indeed(true).and(true).orNot(true)
      )).to.not.throw()
      expect((->
        indeed(true).and(true).butNot(true)
      )).to.not.throw()
    
    it 'should not allow anything after both', ->
      expect((->
        indeed(true).And.both(true).and(true).and(true)
      )).to.throw('IllegalMethodException: and cannot be called with both/and')
      expect((->
        indeed(true).And.both(true).and(true).or(true)
      )).to.throw('IllegalMethodException: or cannot be called with both/and')

  describe '#or', ->
    it 'should "or" the previous result', ->
      expect(indeed(true).or(true).test()).to.be.true
      expect(indeed(true).or(false).test()).to.be.true
      expect(indeed(false).or(true).test()).to.be.true
      expect(indeed(false).or(false).test()).to.be.false

    it 'should allow and, andNot, or, orNot, and butNot', ->
      expect((->
        indeed(true).or(true).and(true)
      )).to.not.throw()
      expect((->
        indeed(true).or(true).andNot(true)
      )).to.not.throw()
      expect((->
        indeed(true).or(true).or(true)
      )).to.not.throw()
      expect((->
        indeed(true).or(true).orNot(true)
      )).to.not.throw()
      expect((->
        indeed(true).or(true).butNot(true)
      )).to.not.throw()

    it 'should not allow anything after either', ->
      expect((->
        indeed(true).And.either(true).or(true).and(true)
      )).to.throw('IllegalMethodException: and cannot be called with either/or')
      expect((->
        indeed(true).And.either(true).or(true).or(true)
      )).to.throw('IllegalMethodException: or cannot be called with either/or')

  describe '#andNot', ->
    it 'should "and not" the previous result', ->
      expect(indeed(false).andNot(true).test()).to.be.false

  describe '#butNot', ->
    it 'should "and not" the previous result', ->
      expect(indeed(false).butNot(true).test()).to.be.false
      
  describe '#orNot', ->
    it 'should "or not" the previous result', ->
      expect(indeed(false).orNot(true).test()).to.be.false

  describe '#xor', ->
    it 'should "xor" the previous result', ->
      expect(indeed(true).xor(false).test()).to.be.true
      expect(indeed(true).xor(true).test()).to.be.false
      expect(indeed(false).xor(false).test()).to.be.false
      expect(indeed(true).xor(false).xor(true).test()).to.be.false

  describe '#indeed', ->
    it 'should reset current', ->
      expect(indeed(true).And.indeed(false).current.pop().val).to.be.false
      expect(indeed(true).And.indeed(false).test()).to.be.false

    it 'should not allow nor', ->
      expect((->
        indeed(true).And.indeed(true).nor(false)
      )).to.throw('IllegalMethodException: nor cannot be called with indeed')
      
  describe '#also', ->
    it 'should reset current', ->
      expect(indeed(true).And.also(false).current.pop().val).to.be.false
      expect(indeed(true).And.also(false).test()).to.be.false

    it 'should not allow nor', ->
      expect((->
        indeed(true).And.indeed(true).nor(false)
      )).to.throw('IllegalMethodException: nor cannot be called with indeed')

  describe '#else', ->
    it 'should reset current', ->
      expect(indeed(true).Or.else(false).current.pop().val).to.be.false
      expect(indeed(true).Or.else(false).test()).to.be.true

    it 'should not allow nor', ->
      expect((->
        indeed(true).And.indeed(true).nor(false)
      )).to.throw('IllegalMethodException: nor cannot be called with indeed')

  describe '#not', ->
    it 'should reset current and negate the first element', ->
      cur = indeed(true).And.not(false).current.pop()
      expect(cur.val).to.be.false
      expect(cur.negate).to.be.true
      expect(indeed(true).And.not(false).test()).to.be.true

    it 'should not allow nor', ->
      expect((->
        indeed(true).And.not(true).nor(false)
      )).to.throw('IllegalMethodException: nor cannot be called with not')

  describe '#And', ->
    it 'should start a new condition set with &&', ->
      result = indeed(true).and(false).And.indeed(true).and(true)
      expect(result.previous.length).to.eql(1)
      expect(result.previous[0]).to.eql
        val: false
        join: 'and'
      expect(_(result.current).last().val).to.be.true
      expect(result.test()).to.be.false

    it 'should work with multiple conditions', ->
      result = indeed(true).and(true).And.indeed(true).and(true).And.indeed(false).or(true).And.indeed(true).butNot(false)
      expect(result.previous.length).to.eql(3)
      expect(result.previous[0]).to.eql
        val: true
        join: 'and'
      expect(result.previous[1]).to.eql
        val: true
        join: 'and'
      expect(result.previous[2]).to.eql
        val: true
        join: 'and'
      last = _(result.current).last()
      expect(last.val).to.be.false
      expect(last.negate).to.be.true
      first = _(result.current).first()
      expect(first.val).to.be.true
      expect(result.test()).to.be.true

  describe '#But', ->
    it 'should start a new condition set with &&', ->
      result = indeed(true).and(false).But.indeed(true).and(true)
      expect(result.previous.length).to.eql(1)
      expect(result.previous[0]).to.eql
        val: false
        join: 'and'
      first = _(result.current).first()
      expect(first.val).to.be.true
      last = _(result.current).last()
      expect(last.val).to.be.true
      expect(result.test()).to.be.false

    it 'should work with multiple conditions', ->
      result = indeed(true).and(true).But.indeed(true).and(true).But.indeed(false).or(true).But.indeed(true).butNot(false)
      expect(result.previous.length).to.eql(3)
      expect(result.previous[0]).to.eql
        val: true
        join: 'and'
      expect(result.previous[1]).to.eql
        val: true
        join: 'and'
      expect(result.previous[2]).to.eql
        val: true
        join: 'and'
      expect(_(result.current).first().val).to.be.true
      last = _(result.current).last()
      expect(last.val).to.be.false
      expect(last.negate).to.be.true
      expect(result.test()).to.be.true

  describe '#Or', ->
    it 'should start a new condition set with ||', ->
      result = indeed(true).and(false).Or.else(true).and(true)
      expect(result.previous.length).to.eql(1)
      expect(result.previous[0]).to.eql
        val: false
        join: 'or'
      expect(_(result.current).first().val).to.be.true
      expect(_(result.current).last().val).to.be.true
      expect(result.test()).to.be.true

  describe '#Not', ->
    it 'should negate a set', ->
      result = indeed(true).and(true).And.Not.also(true).and(false)
      expect(_(result.current).first().val).to.be.true
      expect(_(result.current).last().val).to.be.false
      expect(result.previous[0]).to.eql
        val: true
        join: 'and'
      expect(result.groupNegate).to.be.true
      expect(result.test()).to.be.true

    it 'should negate an or', ->
      result = indeed(true).and(false).Or.Not.also(true).and(false)
      expect(_(result.current).first().val).to.be.true
      expect(_(result.current).last().val).to.be.false
      expect(result.previous[0]).to.eql
        val: false
        join: 'or'
      expect(result.groupNegate).to.be.true
      expect(result.test()).to.be.true

  describe '#Xor', ->
    it 'should start a new condition set with ^', ->
      expect(indeed(true).and(true).Xor.indeed(true).and(true).test()).to.be.false

  describe '#neither', ->
    it 'should start a new condition where both parts are negated', ->
      result = indeed(true).and(true).And.neither(true).nor(false)
      expect(result.previous.length).to.eql(1)
      expect(result.previous[0]).to.eql
        val: true
        join: 'and'
      expect(result.test()).to.be.false

    it 'should allow nor', ->
      expect(( ->
        indeed(true).And.neither(true).or(false)
      )).to.throw('IllegalMethodException: or cannot be called with neither')
      
      expect(( ->
        indeed(true).And.neither(true).and(false)
      )).to.throw('IllegalMethodException: and cannot be called with neither')

      expect(( ->
        indeed(true).And.neither(true).nor(false)
      )).to.not.throw()

  describe '#nor', ->
    it 'should and the negated condition', ->
      expect(indeed(true).And.neither(true).nor(false).current).to.eql [
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
      expect(( ->
        indeed(true).And.neither(true).nor(false).and(true)
      )).to.throw('IllegalMethodException: and cannot be called with neither/nor')

      expect(( ->
        indeed(true).And.neither(true).nor(false).indeed(true)
      )).to.throw('IllegalMethodException: indeed cannot be called with neither/nor')

  describe '#either', ->
    it 'should start a new condition', ->
      expect(indeed(true).And.either(true).or(false).test()).to.be.true

    it 'should allow or', ->
      expect(( ->
        indeed(true).And.either(true).and(true)
      )).to.throw('IllegalMethodException: and cannot be called with either')

      expect(( ->
        indeed(true).And.either(true).nor(true)
      )).to.throw('IllegalMethodException: nor cannot be called with either')

      expect(( ->
        indeed(true).And.either(true).or(true)
      )).to.not.throw()

      expect(( ->
        indeed(true).And.either(true).either(true)
      )).to.throw('IllegalMethodException: either cannot be called with either')

  describe '#both', ->
    it 'should start a new condition', ->
      expect(indeed(true).And.both(true).and(false).test()).to.be.false

    it 'should allow and (once)', ->
      expect(( ->
        indeed(true).And.both(true).and(true)
      )).to.not.throw()

      expect(( ->
        indeed(true).And.both(true).or(true)
      )).to.throw('IllegalMethodException: or cannot be called with both')

      expect(( ->
        indeed(true).And.both(true).and(true).and(true)
      )).to.throw('IllegalMethodException: and cannot be called with both/and')

  describe '#allOf', ->
    it 'should and all conditions', ->
      expect(indeed(true).And.allOf(true).and(true).and(true).test()).to.be.true
      expect(indeed(true).And.allOf(true).and(true).and(true).and(false).test()).to.be.false

    it 'should allow and', ->
      expect(( ->
        indeed(true).And.allOf(true).and(true).or(true)
      )).to.throw('IllegalMethodException: or cannot be called with allOf')

      expect(( ->
        indeed(true).And.allOf(true).and(true).both(false)
      )).to.throw('IllegalMethodException: both cannot be called with allOf')

  describe '#oneOf', ->
    it 'should return true when exactly one condition is true', ->
     expect(indeed(true).And.oneOf(true).and(false).and(false).test()).to.be.true

    it 'should allow and', ->
      expect(( ->
        indeed(true).And.oneOf(true).and(false).or(true)
      )).to.throw('IllegalMethodException: or cannot be called with oneOf')

      expect(( ->
        indeed(true).And.oneOf(true).and(false).else(true)
      )).to.throw('IllegalMethodException: else cannot be called with oneOf')

  describe '#anyOf', ->
    it 'should return true when any one condition is true', ->
      expect(indeed(true).And.anyOf(true).and(false).and(true).test()).to.be.true
      expect(indeed(true).And.anyOf(true).and(false).and(false).test()).to.be.true
      expect(indeed(true).And.anyOf(false).and(true).and(false).test()).to.be.true
      expect(indeed(true).And.anyOf(false).and(false).and(false).test()).to.be.false

    it 'should allow and', ->
      expect(( ->
        indeed(true).And.anyOf(true).and(false).or(true)
      )).to.throw('IllegalMethodException: or cannot be called with anyOf')

      expect(( ->
        indeed(true).And.anyOf(true).and(false).both(true)
      )).to.throw('IllegalMethodException: both cannot be called with anyOf')

  describe '#noneOf', ->
    it 'should return true when all conditions are false', ->
      expect(indeed(true).And.noneOf(false).and(false).and(false).test()).to.be.true
      expect(indeed(true).And.noneOf(true).and(false).and(false).test()).to.be.false

    it 'should allow and', ->
      expect(( ->
        indeed(true).And.noneOf(true).and(false).or(true)
      )).to.throw('IllegalMethodException: or cannot be called with noneOf')

      expect(( ->
        indeed(true).And.noneOf(true).and(false).anyOf(false)
      )).to.throw('IllegalMethodException: anyOf cannot be called with noneOf')

  describe '#is', ->
    context 'with a string', ->
      it 'should be true with the same string', ->
        expect(indeed('string').is('string').test()).to.be.true

      it 'should be false with different strings', ->
        expect(indeed('string').is('nope').test()).to.be.false

    context 'with numbers', ->
      it 'should be true for the same number', ->
        expect(indeed(2).is(2).test()).to.be.true

      it 'should be false for different numbers', ->
        expect(indeed(2).is(4).test()).to.be.false

    context 'with an array', ->
      it 'should be true for reference equality', ->
        @arr = [1,2,3]
        expect(indeed(@arr).is(@arr).test()).to.be.true

      it 'should be false for comparison equality', ->
        expect(indeed([1,2,3]).is([1,2,3]).test()).to.be.false

    context 'with object literals', ->
      it 'should be true for reference equality', ->
        @obj = key: 'value'
        expect(indeed(@obj).is(@obj).test()).to.be.true

      it 'should be false for comparison equality', ->
        expect(indeed(key: 'value').is(key: 'value').test()).to.be.false

    context 'with new-able objects', ->
      it 'should be true for reference equality', ->
        @d = new Date()
        expect(indeed(@d).is(@d).test()).to.be.true

      it 'should be false for comparison equality', ->
        expect(indeed(new Date(2000, 9, 9)).is(new Date(2000, 9, 9)).test()).to.be.false

    context 'with null', ->
      it 'should be true when null', ->
        expect(indeed(null).is(null).test()).to.be.true

    context 'with undefined', ->
      it 'should be true when undefined', ->
        expect(indeed(undefined).is(undefined).test()).to.be.true

  describe '#equal', ->
    context 'with a string', ->
      it 'should be true with the same string', ->
        expect(indeed('string').equals('string').test()).to.be.true

      it 'should be false with different strings', ->
        expect(indeed('string').equals('nope').test()).to.be.false

    context 'with numbers', ->
      it 'should be true for the same number', ->
        expect(indeed(2).equals(2).test()).to.be.true

      it 'should be false for different numbers', ->
        expect(indeed(2).equals(4).test()).to.be.false

    context 'with an array', ->
      it 'should be true for reference equality', ->
        @arr = [1,2,3]
        expect(indeed(@arr).equals(@arr).test()).to.be.true

      it 'should be true for comparison equality', ->
        expect(indeed([1,2,3]).equals([1,2,3]).test()).to.be.true

      it 'should be false for different arrays', ->
        expect(indeed([1,2,3]).equals([4,5,6]).test()).to.be.false

    context 'with object literals', ->
      it 'should be true for reference equality', ->
        @obj = key: 'value'
        expect(indeed(@obj).equals(@obj).test()).to.be.true

      it 'should be true for comparison equality', ->
        expect(indeed(key: 'value').equals(key: 'value').test()).to.be.true

      it 'should  be false for differnt objects', ->
        expect(indeed(key: 'value').equals(hello: 'world').test()).to.be.false

    context 'with new-able objects', ->
      it 'should be true for reference equality', ->
        @d = new Date()
        expect(indeed(@d).equals(@d).test()).to.be.true

      it 'should be true for comparison equality', ->
        expect(indeed(new Date(2000, 9, 9)).equals(new Date(2000, 9, 9)).test()).to.be.true
        
      it 'should be false for different objects', ->
        expect(indeed(new Date(2000, 9, 9)).equals(new Date(1999, 3, 8)).test()).to.be.false

  describe '#isA', ->
    it 'should return true if constructor name matches', ->
      expect(indeed('string').isA('string').test()).to.be.true
      expect(indeed(1).isA('number').test()).to.be.true
      expect(indeed(true).isA('boolean').test()).to.be.true
      expect(indeed(foo: 'bar').isA('object').test()).to.be.true
      expect(indeed([1,2]).isA('Array').test()).to.be.true
      expect(indeed(->).isA('function').test()).to.be.true
      expect(indeed(new Date()).isA('date').test()).to.be.true
      expect(indeed(new (class Foo)()).isA('foo').test()).to.be.true
      
    it 'should return false if constructor name does not match', ->
      expect(indeed('string').isA('object').test()).to.be.false
      expect(indeed(foo: 'bar').isA('thing').test()).to.be.false
      expect(indeed([1,2]).isA('string').test()).to.be.false
      expect(indeed(->).isA('object').test()).to.be.false
      expect(indeed(new Date()).isA('number').test()).to.be.false
      expect(indeed(new (class Foo)()).isA('object').test()).to.be.false

  describe '#isAn', ->
    it 'should return true if constructor name matches', ->
      expect(indeed(foo: 'bar').isAn('object').test()).to.be.true
      expect(indeed([1,2]).isAn('array').test()).to.be.true
      expect(indeed(new (class Aardvark)()).isAn('aardvark').test()).to.be.true
    
    it 'should return false if constructor name does not match', ->
      expect(indeed(1).isAn('object').test()).to.be.false
      expect(indeed(true).isAn('array').test()).to.be.false

  describe '#contains', ->
    it 'should return true if an array contains a value', ->
      expect(indeed([1,2]).contains(2).test()).to.be.true

    it 'should return false if an array does not contain a value', ->
      expect(indeed([1,2]).contains(4).test()).to.be.false

    it 'should return true if a string contains a value', ->
      expect(indeed('hello world').contains('lo').test()).to.be.true

    it 'should return false if a string does not contain a value', ->
      expect(indeed('hello world').contains('foo').test()).to.be.false

  describe '#containsKey', ->
    it 'should return true if an object has a key', ->
      expect(indeed(foo: 'bar').containsKey('foo').test()).to.be.true

    it 'should return false if an object does not have a key', ->
      expect(indeed(foo: 'bar').containsKey('baz').test()).to.be.false

  describe '#containsValue', ->
    it 'should return true if an object has a value', ->
      expect(indeed(foo: 'bar').containsValue('bar').test()).to.be.true

    it 'should return false if an object does not have a value', ->
      expect(indeed(foo: 'bar').containsValue('baz').test()).to.be.false

  describe 'isDefined', ->
    it 'should return true when defined', ->
      expect(indeed('a').isDefined().test()).to.be.true
      expect(indeed([1,2]).isDefined().test()).to.be.true
      expect(indeed(foo: 'bar').isDefined().test()).to.be.true
      expect(indeed(new Date()).isDefined().test()).to.be.true
      expect(indeed(1).isDefined().test()).to.be.true
      expect(indeed(true).isDefined().test()).to.be.true
      expect(indeed(null).isDefined().test()).to.be.true

    it 'should return false when undefined', ->
      expect(indeed(undefined).isDefined().test()).to.be.false

  describe 'isNull', ->
    it 'should return true when null', ->
      expect(indeed(null).isNull().test()).to.be.true

    it 'should return false when not null', ->
      expect(indeed('string').isNull().test()).to.be.false

  describe 'isNotNull', ->
    it 'should return true when not null', ->
      expect(indeed('a').isNotNull().test()).to.be.true
      expect(indeed([1,2]).isNotNull().test()).to.be.true
      expect(indeed(foo: 'bar').isNotNull().test()).to.be.true
      expect(indeed(new Date()).isNotNull().test()).to.be.true
      expect(indeed(1).isNotNull().test()).to.be.true
      expect(indeed(true).isNotNull().test()).to.be.true
      expect(indeed(undefined).isNotNull().test()).to.be.true

  describe 'isTrue', ->
    it 'should return true only when the value is literally "true"', ->
      expect(indeed(true).isTrue().test()).to.be.true

    it 'should return false in all other cases', ->
      expect(indeed(false).isTrue().test()).to.be.false
      expect(indeed(1).isTrue().test()).to.be.false
      expect(indeed([]).isTrue().test()).to.be.false
      expect(indeed({}).isTrue().test()).to.be.false

  describe 'isFalse', ->
    it 'should return true only when the value is literally "false"', ->
      expect(indeed(false).isFalse().test()).to.be.true

    it 'should return false in all other cases', ->
      expect(indeed(true).isFalse().test()).to.be.false
      expect(indeed(0).isFalse().test()).to.be.false
      expect(indeed(undefined).isFalse().test()).to.be.false
      expect(indeed(null).isFalse().test()).to.be.false
      expect(indeed([]).isFalse().test()).to.be.false
      expect(indeed({}).isFalse().test()).to.be.false

  describe '#isGreaterThan', ->
    it 'should return true when greater than', ->
      expect(indeed(4).isGreaterThan(2).test()).to.be.true

    it 'should return false when equal', ->
      expect(indeed(4).isGreaterThan(4).test()).to.be.false

    it 'should return false when less than', ->
      expect(indeed(4).isGreaterThan(7).test()).to.be.false

  describe '#isGt', ->
    it 'should return true when greater than', ->
      expect(indeed(4).isGt(2).test()).to.be.true
    
    it 'should return false when equal', ->
      expect(indeed(4).isGt(4).test()).to.be.false

    it 'should return false when less than', ->
      expect(indeed(4).isGt(7).test()).to.be.false

  describe '#isLessThan', ->
    it 'should return true when less than', ->
      expect(indeed(2).isLessThan(4).test()).to.be.true

    it 'should return false when equal', ->
      expect(indeed(4).isLessThan(4).test()).to.be.false

    it 'should return false when greater than', ->
      expect(indeed(4).isLessThan(2).test()).to.be.false

  describe '#isLt', ->
    it 'should return true when less than', ->
      expect(indeed(2).isLt(4).test()).to.be.true

    it 'should return false when equal', ->
      expect(indeed(4).isLt(4).test()).to.be.false

    it 'should return false when greater than', ->
      expect(indeed(4).isLt(2).test()).to.be.false

  describe '#isGreaterThanOrEqualTo', ->
    it 'should return true when greater than or equal to', ->
      expect(indeed(4).isGreaterThanOrEqualTo(2).test()).to.be.true

    it 'should return true when equal', ->
      expect(indeed(2).isGreaterThanOrEqualTo(2).test()).to.be.true

    it 'should return false when less than', ->
      expect(indeed(1).isGreaterThanOrEqualTo(2).test()).to.be.false

  describe '#isGte', ->
    it 'should return true when greater than or equal to', ->
      expect(indeed(4).isGte(2).test()).to.be.true

    it 'should return true when equal', ->
      expect(indeed(2).isGte(2).test()).to.be.true

    it 'should return false when less than', ->
      expect(indeed(1).isGte(2).test()).to.be.false

  describe '#isLessThanOrEqualTo', ->
    it 'should return true when less than', ->
      expect(indeed(2).isLessThanOrEqualTo(4).test()).to.be.true

    it 'should return true when equal', ->
      expect(indeed(4).isLessThanOrEqualTo(4).test()).to.be.true

    it 'should return false when greater than', ->
      expect(indeed(4).isLessThanOrEqualTo(2).test()).to.be.false

  describe '#isLte', ->
    it 'should return true when less than', ->
      expect(indeed(2).isLte(4).test()).to.be.true

    it 'should return true when equal', ->
      expect(indeed(4).isLte(4).test()).to.be.true

    it 'should return false when greater than', ->
      expect(indeed(4).isLte(2).test()).to.be.false

  describe '#mixin', ->
    it 'should add a new compare method to Indeed.prototype', ->
      indeed.mixin
        isLengthFive: (condition) ->
          return (val) -> _(val).isArray() && val.length == 5
        startsWith: (condition) ->
          return (val) -> val.charAt(0) == condition
      expect(indeed([1,2,3,4,5]).isLengthFive().test()).to.be.true
      expect(indeed('apple').startsWith('a').test()).to.be.true
