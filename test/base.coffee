Base = require('./../lib/base')
base = new Base()

describe 'base', ->
  describe '#mixin', ->
    it 'should add a new compare method to Base.prototype', ->
      base.mixin
        isLengthFive: (condition) ->
          return (val) -> _(val).isArray() && val.length == 5
        startsWith: (condition) ->
          return (val) -> val.charAt(0) == condition
      Base.prototype.isLengthFive.should.be.a.Function
      Base.prototype.startsWith.should.be.a.Function

  describe 'comparison methods', ->
    beforeEach ->
      base.current = [
        val: false
        actual: 'thing'
      ]

    describe '#_compare', ->
      it 'should update current', ->
        base._compare('foo', (actual) ->
          return actual + ' baby'
        ).current.should.eql [
          val: 'thing baby'
          actual: 'thing'
          compare: 'foo'
        ]

    describe '#is', ->
      it 'should be true on a match', ->
        base.is('thing').current[0].val.should.be.true

      it 'should be false on no match', ->
        base.is('other thing').current[0].val.should.be.false

      it 'should be true on referential equality', ->
        arr = [1,2,3]
        base.current = [
          val: true
          actual: arr
        ]
        base.is(arr).current[0].val.should.be.true

      it 'should be false on non-referential equality', ->
        base.current = [
          val: true
          actual: [1,2,3]
        ]
        base.is([1,2,3]).current[0].val.should.be.false

    describe '#equals', ->
      it 'should be true for matching strings', ->
        base.equals('thing').current[0].val.should.be.true

      it 'should be true for matching numbers', ->
        base.current = [
          val: true
          actual: 2
        ]
        base.equals(2).current[0].val.should.be.true

      it 'should be true for matching booleans', ->
        base.current = [
          val: true
          actual: true
        ]
        base.equals(true).current[0].val.should.be.true

      it 'should be true for matching arrays', ->
        base.current = [
          val: true
          actual: [1,2,3]
        ]
        base.equals([1,2,3]).current[0].val.should.be.true

      it 'should be true for matching objects', ->
        base.current = [
          val: true
          actual:
            foo: 'bar'
        ]
        base.equals(foo: 'bar').current[0].val.should.be.true

      it 'should be true for matching newable objects', ->
        base.current = [
          val: true
          actual: new Date(2000, 9, 9)
        ]
        base.equals(new Date(2000, 9, 9)).current[0].val.should.be.true

    describe '#isA', ->
      it 'should be true for strings', ->
        base.isA('string').current[0].val.should.be.true

      it 'should should be true for arrays', ->
        base.current = [
          val: false
          actual: [1,2,3]
        ]
        base.isA('array').current[0].val.should.be.true

      it 'should be true for objects', ->
        base.current = [
          val: false
          actual:
            foo: 'bar'
        ]
        base.isA('object').current[0].val.should.be.true

      it 'should be true for new-able types', ->
        base.current = [
          val: false
          actual: new Date(2000, 9, 9)
        ]
        base.isA('date').current[0].val.should.be.true

      it 'should be true for custom types', ->
        base.current = [
          val: false
          actual: new (class Thing)()
        ]
        base.isA('thing').current[0].val.should.be.true

      it 'should be false for different types', ->
        base.current = [
          val: true
          actual: 'something'
        ]
        base.isA('spaceship').current[0].val.should.be.false

      it 'should be false for null', ->
        base.current = [
          val: true
          actual: null
        ]
        base.isA('null').current[0].val.should.be.false

      it 'should be false for undefined', ->
        base.current = [
          val: true
          actual: undefined
        ]
        base.isA('undefined').current[0].val.should.be.false

    describe '#isAn', ->
      it 'should be true for strings', ->
        base.isAn('string').current[0].val.should.be.true

      it 'should should be true for arrays', ->
        base.current = [
          val: false
          actual: [1,2,3]
        ]
        base.isAn('array').current[0].val.should.be.true

      it 'should be true for objects', ->
        base.current = [
          val: false
          actual:
            foo: 'bar'
        ]
        base.isAn('object').current[0].val.should.be.true

      it 'should be true for new-able types', ->
        base.current = [
          val: false
          actual: new Date(2000, 9, 9)
        ]
        base.isAn('date').current[0].val.should.be.true

      it 'should be true for custom types', ->
        base.current = [
          val: false
          actual: new (class Thing)()
        ]
        base.isAn('thing').current[0].val.should.be.true

      it 'should be false for different types', ->
        base.current = [
          val: true
          actual: 'something'
        ]
        base.isAn('spaceship').current[0].val.should.be.false

      it 'should be false for null', ->
        base.current = [
          val: true
          actual: null
        ]
        base.isAn('null').current[0].val.should.be.false

      it 'should be false for undefined', ->
        base.current = [
          val: true
          actual: undefined
        ]
        base.isAn('undefined').current[0].val.should.be.false

    describe '#contains', ->
      it 'should be true for arrays containing the value', ->
        base.current = [
          val: false
          actual: [1,2,3]
        ]
        base.contains(1).current[0].val.should.be.true

      it 'should be false for arrays not containing the value', ->
        base.current = [
          val: true
          actual: [1,2,3]
        ]
        base.contains(4).current[0].val.should.be.false

      it 'should be true for strings containing the value', ->
        base.contains('in').current[0].val.should.be.true

      it 'should be false for strings not containing the value', ->
        base.contains('world').current[0].val.should.be.false

      it 'should be false for other types', ->
        base.current = [
          val: true
          actual:
            foo: 'bar'
        ]
        base.contains('bar').current[0].val.should.be.false

    describe '#containsKey', ->
      it 'should be true for objects with the key', ->
        base.current = [
          val: false
          actual:
            foo: 'bar'
        ]
        base.containsKey('foo').current[0].val.should.be.true

      it 'should be false for objects without the key', ->
        base.current = [
          val: true
          actual:
            foo: 'bar'
        ]
        base.containsKey('baz').current[0].val.should.be.false

      it 'should be false for non-objects', ->
        base.current = [
          val: true
          actual: 2
        ]
        base.containsKey('baz').current[0].val.should.be.false
