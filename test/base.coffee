expect = require('chai').expect
Base = require('./../lib/base')
base = new Base()

describe 'base', ->
  describe 'comparison methods', ->
    beforeEach ->
      base.current = [
        val: false
        actual: 'thing'
      ]

    describe '#_compare', ->
      it 'should update current', ->
        expect(base._compare('foo', (actual) ->
          return actual + ' baby'
        ).current).to.eql [
          val: 'thing baby'
          actual: 'thing'
          compare: 'foo'
        ]

    describe '#is', ->
      it 'should be true on a match', ->
        expect(base.is('thing').current[0].val).to.be.true

      it 'should be false on no match', ->
        expect(base.is('other thing').current[0].val).to.be.false

      it 'should be true on referential equality', ->
        arr = [1,2,3]
        base.current = [
          val: true
          actual: arr
        ]
        expect(base.is(arr).current[0].val).to.be.true

      it 'should be false on non-referential equality', ->
        base.current = [
          val: true
          actual: [1,2,3]
        ]
        expect(base.is([1,2,3]).current[0].val).to.be.false

    describe '#equals', ->
      it 'should be true for matching strings', ->
        expect(base.equals('thing').current[0].val).to.be.true

      it 'should be true for matching numbers', ->
        base.current = [
          val: true
          actual: 2
        ]
        expect(base.equals(2).current[0].val).to.be.true

      it 'should be true for matching booleans', ->
        base.current = [
          val: true
          actual: true
        ]
        expect(base.equals(true).current[0].val).to.be.true

      it 'should be true for matching arrays', ->
        base.current = [
          val: true
          actual: [1,2,3]
        ]
        expect(base.equals([1,2,3]).current[0].val).to.be.true

      it 'should be true for matching objects', ->
        base.current = [
          val: true
          actual:
            foo: 'bar'
        ]
        expect(base.equals(foo: 'bar').current[0].val).to.be.true

      it 'should be true for matching newable objects', ->
        base.current = [
          val: true
          actual: new Date(2000, 9, 9)
        ]
        expect(base.equals(new Date(2000, 9, 9)).current[0].val).to.be.true

    describe '#isA', ->
      it 'should be true for strings', ->
        expect(base.isA('string').current[0].val).to.be.true

      it 'should be true for arrays', ->
        base.current = [
          val: false
          actual: [1,2,3]
        ]
        expect(base.isA('array').current[0].val).to.be.true

      it 'should be true for objects', ->
        base.current = [
          val: false
          actual:
            foo: 'bar'
        ]
        expect(base.isA('object').current[0].val).to.be.true

      it 'should be true for new-able types', ->
        base.current = [
          val: false
          actual: new Date(2000, 9, 9)
        ]
        expect(base.isA('date').current[0].val).to.be.true

      it 'should be true for custom types', ->
        base.current = [
          val: false
          actual: new (class Thing)()
        ]
        expect(base.isA('thing').current[0].val).to.be.true

      it 'should be false for different types', ->
        base.current = [
          val: true
          actual: 'something'
        ]
        expect(base.isA('spaceship').current[0].val).to.be.false

      it 'should be false for null', ->
        base.current = [
          val: true
          actual: null
        ]
        expect(base.isA('null').current[0].val).to.be.false

      it 'should be false for undefined', ->
        base.current = [
          val: true
          actual: undefined
        ]
        expect(base.isA('undefined').current[0].val).to.be.false

    describe '#isAn', ->
      it 'should be true for strings', ->
        expect(base.isAn('string').current[0].val).to.be.true

      it 'should be true for arrays', ->
        base.current = [
          val: false
          actual: [1,2,3]
        ]
        expect(base.isAn('array').current[0].val).to.be.true

      it 'should be true for objects', ->
        base.current = [
          val: false
          actual:
            foo: 'bar'
        ]
        expect(base.isAn('object').current[0].val).to.be.true

      it 'should be true for new-able types', ->
        base.current = [
          val: false
          actual: new Date(2000, 9, 9)
        ]
        expect(base.isAn('date').current[0].val).to.be.true

      it 'should be true for custom types', ->
        base.current = [
          val: false
          actual: new (class Thing)()
        ]
        expect(base.isAn('thing').current[0].val).to.be.true

      it 'should be false for different types', ->
        base.current = [
          val: true
          actual: 'something'
        ]
        expect(base.isAn('spaceship').current[0].val).to.be.false

      it 'should be false for null', ->
        base.current = [
          val: true
          actual: null
        ]
        expect(base.isAn('null').current[0].val).to.be.false

      it 'should be false for undefined', ->
        base.current = [
          val: true
          actual: undefined
        ]
        expect(base.isAn('undefined').current[0].val).to.be.false

    describe '#contains', ->
      it 'should be true for arrays containing the value', ->
        base.current = [
          val: false
          actual: [1,2,3]
        ]
        expect(base.contains(1).current[0].val).to.be.true

      it 'should be false for arrays not containing the value', ->
        base.current = [
          val: true
          actual: [1,2,3]
        ]
        expect(base.contains(4).current[0].val).to.be.false

      it 'should be true for strings containing the value', ->
        expect(base.contains('in').current[0].val).to.be.true

      it 'should be false for strings not containing the value', ->
        expect(base.contains('world').current[0].val).to.be.false

      it 'should be false for other types', ->
        base.current = [
          val: true
          actual:
            foo: 'bar'
        ]
        expect(base.contains('bar').current[0].val).to.be.false

    describe '#containsKey', ->
      it 'should be true for objects with the key', ->
        base.current = [
          val: false
          actual:
            foo: 'bar'
        ]
        expect(base.containsKey('foo').current[0].val).to.be.true

      it 'should be false for objects without the key', ->
        base.current = [
          val: true
          actual:
            foo: 'bar'
        ]
        expect(base.containsKey('baz').current[0].val).to.be.false

      it 'should be true for arrays with the index', ->
        base.current = [
          val: false
          actual: [1,2,3]
        ]
        expect(base.containsKey('0').current[0].val).to.be.true

      it 'should be false for arrays without the index', ->
        base.current = [
          val: true
          actual: [1,2,3]
        ]
        expect(base.containsKey('5').current[0].val).to.be.false

      it 'should be false for non-objects', ->
        base.current = [
          val: true
          actual: 2
        ]
        expect(base.containsKey('baz').current[0].val).to.be.false

    describe '#containsValue', ->
      it 'should be true for objects with the value', ->
        base.current = [
          val: false
          actual:
            foo: 'bar'
        ]
        expect(base.containsValue('bar').current[0].val).to.be.true

      it 'should be false for objects without the value', ->
        base.current = [
          val: true
          actual:
            foo: 'bar'
        ]
        expect(base.containsValue('thing').current[0].val).to.be.false

      it 'should be true for arrays with the value', ->
        base.current = [
          val: false
          actual: [1,2,3]
        ]
        expect(base.containsValue(2).current[0].val).to.be.true

      it 'should be false for arrays without the value', ->
        base.current = [
          val: true
          actual: [1,2,3]
        ]
        expect(base.containsValue(5).current[0].val).to.be.false

      it 'should be false for other types', ->
        expect(base.containsValue('i').current[0].val).to.be.false

    describe '#isDefined', ->
      it 'should be false for undefined', ->
        base.current = [
          val: true
          actual: undefined
        ]
        expect(base.isDefined().current[0].val).to.be.false

      it 'should be true for other things', ->
        expect(base.isDefined().current[0].val).to.be.true

    describe '#isUndefined', ->
      it 'should be true for undefined', ->
        base.current = [
          val: false
          actual: undefined
        ]
        expect(base.isUndefined().current[0].val).to.be.true

      it 'should be false for other things', ->
        base.current = [
          val: true
          actual: null
        ]
        expect(base.isUndefined().current[0].val).to.be.false

    describe '#isNull', ->
      it 'should be true for null', ->
        base.current = [
          val: false
          actual: null
        ]
        expect(base.isNull().current[0].val).to.be.true

      it 'should be false for other things', ->
        expect(base.isNull().current[0].val).to.be.false

    describe '#isNotNull', ->
      it 'should be false for null', ->
        base.current = [
          val: true
          actual: null
        ]
        expect(base.isNotNull().current[0].val).to.be.false

      it 'should be true for other things', ->
        expect(base.isNotNull().current[0].val).to.be.true

    describe '#isTrue', ->
      it 'should be true for true', ->
        base.current = [
          val: false
          actual: true
        ]
        expect(base.isTrue().current[0].val).to.be.true

      it 'should be false for false', ->
        base.current = [
          val: true
          actual: false
        ]
        expect(base.isTrue().current[0].val).to.be.false

      it 'should be false for non-booleans', ->
        expect(base.isTrue().current[0].val).to.be.false

    describe '#isFalse', ->
      it 'should be true for false', ->
        base.current = [
          val: false
          actual: false
        ]
        expect(base.isFalse().current[0].val).to.be.true

      it 'should be false for true', ->
        base.current = [
          val: true
          actual: true
        ]
        expect(base.isFalse().current[0].val).to.be.false

      it 'should be false for non-booleans', ->
        expect(base.isFalse().current[0].val).to.be.false

    describe '#isGreaterThan', ->
      it 'should be true for bigger numbers', ->
        base.current = [
          val: false
          actual: 2
        ]
        expect(base.isGreaterThan(1).current[0].val).to.be.true

      it 'should be false for equal numbers', ->
        base.current = [
          val: true
          actual: 2
        ]
        expect(base.isGreaterThan(2).current[0].val).to.be.false

      it 'should be false for smaller numbers', ->
        base.current = [
          val: false
          actual: 2
        ]
        expect(base.isGreaterThan(5).current[0].val).to.be.false

      it 'should be false for non-numbers', ->
        expect(base.isGreaterThan(2).current[0].val).to.be.false

    describe '#isLessThan', ->
      it 'should be true for smaller numbers', ->
        base.current = [
          val: false
          actual: 2
        ]
        expect(base.isLessThan(5).current[0].val).to.be.true

      it 'should be false for equal numbers', ->
        base.current = [
          val: true
          actual: 2
        ]
        expect(base.isLessThan(2).current[0].val).to.be.false

      it 'should be false for bigger numbers', ->
        base.current = [
          val: false
          actual: 2
        ]
        expect(base.isLessThan(1).current[0].val).to.be.false

      it 'should be false for non-numbers', ->
        expect(base.isLessThan(2).current[0].val).to.be.false

    describe '#isGreaterThanOrEqualTo', ->
      it 'should be true for bigger numbers', ->
        base.current = [
          val: false
          actual: 2
        ]
        expect(base.isGreaterThanOrEqualTo(1).current[0].val).to.be.true

      it 'should be true for equal numbers', ->
        base.current = [
          val: false
          actual: 2
        ]
        expect(base.isGreaterThanOrEqualTo(2).current[0].val).to.be.true

      it 'should be false for smaller numbers', ->
        base.current = [
          val: false
          actual: 2
        ]
        expect(base.isGreaterThanOrEqualTo(5).current[0].val).to.be.false

      it 'should be false for non-numbers', ->
        expect(base.isGreaterThanOrEqualTo(2).current[0].val).to.be.false

    describe '#isLessThanOrEqualTo', ->
      it 'should be true for smaller numbers', ->
        base.current = [
          val: false
          actual: 2
        ]
        expect(base.isLessThanOrEqualTo(5).current[0].val).to.be.true

      it 'should be true for equal numbers', ->
        base.current = [
          val: false
          actual: 2
        ]
        expect(base.isLessThanOrEqualTo(2).current[0].val).to.be.true

      it 'should be false for smaller numbers', ->
        base.current = [
          val: false
          actual: 2
        ]
        expect(base.isLessThanOrEqualTo(1).current[0].val).to.be.false

      it 'should be false for non-numbers', ->
        expect(base.isLessThanOrEqualTo(2).current[0].val).to.be.false
