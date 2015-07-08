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
    expect(indeed.Not(true).flags.groupNot).to.be.true
    expect(indeed.chain(true).flags.chain).to.be.true
    expect(indeed.not.chain(true).current).to.eql [
      val: true
      negate: true
      actual: true
    ]
    expect(indeed.not.chain(true).flags.chain).to.be.true
    expect(indeed.Not.chain(true).flags).to.eql
      not: false
      groupNot: true
      chain: true
      deep: false
      noCase: false

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
        )).to.throw('IllegalMethodException: and cannot be chained with neither')

  describe '#test', ->
    context 'no previous values', ->
      it 'should return basic values', ->
        expect(indeed(true).test()).to.be.true
        expect(indeed(false).test()).to.be.false

      it 'should return the value of current', ->
        result = indeed(true)
        expect(result.test()).to.be.true

      it 'should apply flags.groupNot', ->
        result = indeed(true)
        result.flags.groupNot = true
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

      it 'should apply flags.groupNot', ->
        result = indeed(true)
        result.flags.groupNot = true
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

      it 'should apply flags.groupNot', ->
        result = indeed(true)
        result.flags.groupNot = true
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
      )).to.throw('IllegalMethodException: and cannot be chained with both/and')
      expect((->
        indeed(true).And.both(true).and(true).or(true)
      )).to.throw('IllegalMethodException: or cannot be chained with both/and')

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
      )).to.throw('IllegalMethodException: and cannot be chained with either/or')
      expect((->
        indeed(true).And.either(true).or(true).or(true)
      )).to.throw('IllegalMethodException: or cannot be chained with either/or')

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
      )).to.throw('IllegalMethodException: nor cannot be chained with indeed')
      
  describe '#also', ->
    it 'should reset current', ->
      expect(indeed(true).And.also(false).current.pop().val).to.be.false
      expect(indeed(true).And.also(false).test()).to.be.false

    it 'should not allow nor', ->
      expect((->
        indeed(true).And.indeed(true).nor(false)
      )).to.throw('IllegalMethodException: nor cannot be chained with indeed')

  describe '#else', ->
    it 'should reset current', ->
      expect(indeed(true).Or.else(false).current.pop().val).to.be.false
      expect(indeed(true).Or.else(false).test()).to.be.true

    it 'should not allow nor', ->
      expect((->
        indeed(true).And.indeed(true).nor(false)
      )).to.throw('IllegalMethodException: nor cannot be chained with indeed')

  describe '#And', ->
    it 'should start a new condition set with &&', ->
      result = indeed(true).and(false).And.indeed(true).and(true)
      expect(result.previous.length).to.eql(1)
      expect(result.previous[0]).to.eql
        val: false
        join: 'and'
      expect(_.last(result.current).val).to.be.true
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
      last = _.last(result.current)
      expect(last.val).to.be.false
      expect(last.negate).to.be.true
      first = _.first(result.current)
      expect(first.val).to.be.true
      expect(result.test()).to.be.true

  describe '#But', ->
    it 'should start a new condition set with &&', ->
      result = indeed(true).and(false).But.indeed(true).and(true)
      expect(result.previous.length).to.eql(1)
      expect(result.previous[0]).to.eql
        val: false
        join: 'and'
      first = _.first(result.current)
      expect(first.val).to.be.true
      last = _.last(result.current)
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
      expect(_.first(result.current).val).to.be.true
      last = _.last(result.current)
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
      expect(_.first(result.current).val).to.be.true
      expect(_.last(result.current).val).to.be.true
      expect(result.test()).to.be.true

  describe '#Not', ->
    it 'should negate a set', ->
      result = indeed(true).and(true).And.Not.also(true).and(false)
      expect(_.first(result.current).val).to.be.true
      expect(_.last(result.current).val).to.be.false
      expect(result.previous[0]).to.eql
        val: true
        join: 'and'
      expect(result.flags.groupNot).to.be.true
      expect(result.test()).to.be.true

    it 'should negate an or', ->
      result = indeed(true).and(false).Or.Not.also(true).and(false)
      expect(_.first(result.current).val).to.be.true
      expect(_.last(result.current).val).to.be.false
      expect(result.previous[0]).to.eql
        val: false
        join: 'or'
      expect(result.flags.groupNot).to.be.true
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
      )).to.throw('IllegalMethodException: or cannot be chained with neither')
      
      expect(( ->
        indeed(true).And.neither(true).and(false)
      )).to.throw('IllegalMethodException: and cannot be chained with neither')

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
      )).to.throw('IllegalMethodException: and cannot be chained with neither/nor')

      expect(( ->
        indeed(true).And.neither(true).nor(false).indeed(true)
      )).to.throw('IllegalMethodException: indeed cannot be chained with neither/nor')

  describe '#either', ->
    it 'should start a new condition', ->
      expect(indeed(true).And.either(true).or(false).test()).to.be.true

    it 'should allow or', ->
      expect(( ->
        indeed(true).And.either(true).and(true)
      )).to.throw('IllegalMethodException: and cannot be chained with either')

      expect(( ->
        indeed(true).And.either(true).nor(true)
      )).to.throw('IllegalMethodException: nor cannot be chained with either')

      expect(( ->
        indeed(true).And.either(true).or(true)
      )).to.not.throw()

      expect(( ->
        indeed(true).And.either(true).either(true)
      )).to.throw('IllegalMethodException: either cannot be chained with either')

  describe '#both', ->
    it 'should start a new condition', ->
      expect(indeed(true).And.both(true).and(false).test()).to.be.false

    it 'should allow and (once)', ->
      expect(( ->
        indeed(true).And.both(true).and(true)
      )).to.not.throw()

      expect(( ->
        indeed(true).And.both(true).or(true)
      )).to.throw('IllegalMethodException: or cannot be chained with both')

      expect(( ->
        indeed(true).And.both(true).and(true).and(true)
      )).to.throw('IllegalMethodException: and cannot be chained with both/and')

  describe '#allOf', ->
    it 'should and all conditions', ->
      expect(indeed(true).And.allOf(true).and(true).and(true).test()).to.be.true
      expect(indeed(true).And.allOf(true).and(true).and(true).and(false).test()).to.be.false

    it 'should allow and', ->
      expect(( ->
        indeed(true).And.allOf(true).and(true).or(true)
      )).to.throw('IllegalMethodException: or cannot be chained with allOf')

      expect(( ->
        indeed(true).And.allOf(true).and(true).both(false)
      )).to.throw('IllegalMethodException: both cannot be chained with allOf')

  describe '#oneOf', ->
    it 'should return true when exactly one condition is true', ->
     expect(indeed(true).And.oneOf(true).and(false).and(false).test()).to.be.true

    it 'should allow and', ->
      expect(( ->
        indeed(true).And.oneOf(true).and(false).or(true)
      )).to.throw('IllegalMethodException: or cannot be chained with oneOf')

      expect(( ->
        indeed(true).And.oneOf(true).and(false).else(true)
      )).to.throw('IllegalMethodException: else cannot be chained with oneOf')

  describe '#anyOf', ->
    it 'should return true when any one condition is true', ->
      expect(indeed(true).And.anyOf(true).and(false).and(true).test()).to.be.true
      expect(indeed(true).And.anyOf(true).and(false).and(false).test()).to.be.true
      expect(indeed(true).And.anyOf(false).and(true).and(false).test()).to.be.true
      expect(indeed(true).And.anyOf(false).and(false).and(false).test()).to.be.false

    it 'should allow and', ->
      expect(( ->
        indeed(true).And.anyOf(true).and(false).or(true)
      )).to.throw('IllegalMethodException: or cannot be chained with anyOf')

      expect(( ->
        indeed(true).And.anyOf(true).and(false).both(true)
      )).to.throw('IllegalMethodException: both cannot be chained with anyOf')

  describe '#noneOf', ->
    it 'should return true when all conditions are false', ->
      expect(indeed(true).And.noneOf(false).and(false).and(false).test()).to.be.true
      expect(indeed(true).And.noneOf(true).and(false).and(false).test()).to.be.false

    it 'should allow and', ->
      expect(( ->
        indeed(true).And.noneOf(true).and(false).or(true)
      )).to.throw('IllegalMethodException: or cannot be chained with noneOf')

      expect(( ->
        indeed(true).And.noneOf(true).and(false).anyOf(false)
      )).to.throw('IllegalMethodException: anyOf cannot be chained with noneOf')

  describe '#equal', ->
    context 'shallow equals', ->
      it 'should be true with the same string', ->
        expect(indeed('string').equals('string')).to.be.true

      it 'should be false with different strings', ->
        expect(indeed('string').equals('nope')).to.be.false

      it 'should be true for the same number', ->
        expect(indeed(2).equals(2)).to.be.true

      it 'should be false for different numbers', ->
        expect(indeed(2).equals(4)).to.be.false

    context 'deep equals', ->
      it 'should be true for reference equality', ->
        @arr = [1,2,3]
        expect(indeed(@arr).deep.equals(@arr)).to.be.true

      it 'should be true for comparison equality', ->
        expect(indeed([1,2,3]).deep.equals([1,2,3])).to.be.true

      it 'should be false for different arrays', ->
        expect(indeed([1,2,3]).deep.equals([4,5,6])).to.be.false

      it 'should be true for reference equality', ->
        @obj = key: 'value'
        expect(indeed(@obj).deep.equals(@obj)).to.be.true

      it 'should be true for comparison equality', ->
        expect(indeed(key: 'value').deep.equals(key: 'value')).to.be.true

      it 'should  be false for differnt objects', ->
        expect(indeed(key: 'value').deep.equals(hello: 'world')).to.be.false

      it 'should be true for reference equality', ->
        @d = new Date()
        expect(indeed(@d).deep.equals(@d)).to.be.true

      it 'should be true for comparison equality', ->
        expect(indeed(new Date(2000, 9, 9)).deep.equals(new Date(2000, 9, 9))).to.be.true
        
      it 'should be false for different objects', ->
        expect(indeed(new Date(2000, 9, 9)).deep.equals(new Date(1999, 3, 8))).to.be.false

  describe '#a', ->
    it 'should return true if constructor name matches', ->
      expect(indeed('string').is.a('string')).to.be.true
      expect(indeed(1).is.a('number')).to.be.true
      expect(indeed(true).is.a('boolean')).to.be.true
      expect(indeed(foo: 'bar').is.a('object')).to.be.true
      expect(indeed([1,2]).is.a('Array')).to.be.true
      expect(indeed(->).is.a('function')).to.be.true
      expect(indeed(new Date()).is.a('date')).to.be.true
      expect(indeed(new (class Foo)()).is.a('foo')).to.be.true
      
    it 'should return false if constructor name does not match', ->
      expect(indeed('string').is.a('object')).to.be.false
      expect(indeed(foo: 'bar').is.a('thing')).to.be.false
      expect(indeed([1,2]).is.a('string')).to.be.false
      expect(indeed(->).is.a('object')).to.be.false
      expect(indeed(new Date()).is.a('number')).to.be.false
      expect(indeed(new (class Foo)()).is.a('object')).to.be.false

  describe '#contains', ->
    it 'should return true if an array contains a value', ->
      expect(indeed([1,2]).contains(2)).to.be.true

    it 'should return false if an array does not contain a value', ->
      expect(indeed([1,2]).contains(4)).to.be.false

    it 'should return true if a string contains a value', ->
      expect(indeed('hello world').contains('lo')).to.be.true

    it 'should return false if a string does not contain a value', ->
      expect(indeed('hello world').contains('foo')).to.be.false

  describe '#key', ->
    it 'should return true if an object has a key', ->
      expect(indeed(foo: 'bar').key('foo')).to.be.true

    it 'should return false if an object does not have a key', ->
      expect(indeed(foo: 'bar').key('baz')).to.be.false

  describe '#value', ->
    it 'should return true if an object has a value', ->
      expect(indeed(foo: 'bar').value('bar')).to.be.true

    it 'should return false if an object does not have a value', ->
      expect(indeed(foo: 'bar').value('baz')).to.be.false

  describe '#defined', ->
    it 'should return true when defined', ->
      expect(indeed('a').is.defined()).to.be.true
      expect(indeed([1,2]).is.defined()).to.be.true
      expect(indeed(foo: 'bar').is.defined()).to.be.true
      expect(indeed(new Date()).is.defined()).to.be.true
      expect(indeed(1).is.defined()).to.be.true
      expect(indeed(true).is.defined()).to.be.true
      expect(indeed(null).is.defined()).to.be.true

    it 'should return false when undefined', ->
      expect(indeed(undefined).is.defined()).to.be.false

  describe '#null', ->
    it 'should return true when null', ->
      expect(indeed(null).is.null()).to.be.true

    it 'should return false when not null', ->
      expect(indeed('string').is.null()).to.be.false

  describe '#true', ->
    it 'should return true only when the value is literally "true"', ->
      expect(indeed(true).is.true()).to.be.true

    it 'should return false in all other cases', ->
      expect(indeed(false).is.true()).to.be.false
      expect(indeed(1).is.true()).to.be.false
      expect(indeed([]).is.true()).to.be.false
      expect(indeed({}).is.true()).to.be.false

  describe '#false', ->
    it 'should return true only when the value is literally "false"', ->
      expect(indeed(false).is.false()).to.be.true

    it 'should return false in all other cases', ->
      expect(indeed(true).is.false()).to.be.false
      expect(indeed(0).is.false()).to.be.false
      expect(indeed(undefined).is.false()).to.be.false
      expect(indeed(null).is.false()).to.be.false
      expect(indeed([]).is.false()).to.be.false
      expect(indeed({}).is.false()).to.be.false

  describe '#greaterThan', ->
    it 'should return true when greater than', ->
      expect(indeed(4).is.greaterThan(2)).to.be.true

    it 'should return false when equal', ->
      expect(indeed(4).is.greaterThan(4)).to.be.false

    it 'should return false when less than', ->
      expect(indeed(4).is.greaterThan(7)).to.be.false

  describe '#lessThan', ->
    it 'should return true when less than', ->
      expect(indeed(2).is.lessThan(4)).to.be.true

    it 'should return false when equal', ->
      expect(indeed(4).is.lessThan(4)).to.be.false

    it 'should return false when greater than', ->
      expect(indeed(4).is.lessThan(2)).to.be.false

  describe '#greaterThanOrEqualTo', ->
    it 'should return true when greater than or equal to', ->
      expect(indeed(4).is.greaterThanOrEqualTo(2)).to.be.true

    it 'should return true when equal', ->
      expect(indeed(2).is.greaterThanOrEqualTo(2)).to.be.true

    it 'should return false when less than', ->
      expect(indeed(1).is.greaterThanOrEqualTo(2)).to.be.false

  describe '#is.lessThanOrEqualTo', ->
    it 'should return true when less than', ->
      expect(indeed(2).is.lessThanOrEqualTo(4)).to.be.true

    it 'should return true when equal', ->
      expect(indeed(4).is.lessThanOrEqualTo(4)).to.be.true

    it 'should return false when greater than', ->
      expect(indeed(4).is.lessThanOrEqualTo(2)).to.be.false

  describe '#mixin', ->
    it 'should add a new compare method to Indeed.prototype', ->
      indeed.mixin
        isLengthFive: (condition) ->
          return (val) -> _.isArray(val) && val.length == 5
        startsWith: (condition) ->
          return (val) -> val.charAt(0) == condition
      expect(indeed([1,2,3,4,5]).isLengthFive()).to.be.true
      expect(indeed('apple').startsWith('a')).to.be.true
