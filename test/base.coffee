expect = require('chai').expect
Base = require('./../lib/base')
base = new Base()

describe 'base', ->
  beforeEach ->
    base.current = [
      val: false
      actual: 'thing'
    ]

  beforeEach ->
    base.flags.deep = false
    base.flags.not = false
    base.flags.groupNot = false

  describe '#_compare', ->
    it 'should update current', ->
      base.flags =
        not: false
      expect(base._compare((actual) ->
        return actual + ' baby'
      ).current).to.eql [
        val: true
        actual: 'thing'
      ]

  describe '#equals', ->
    context 'shallow equals', ->
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

      it 'should be false for objects', ->
        base.current = [
          val: true
          actual: {}
        ]
        expect(base.equals({}).current[0].val).to.be.false

      it 'should be false for arrays', ->
        base.current = [
          val: true
          actual: []
        ]
        expect(base.equals([]).current[0].val).to.be.false

    context 'deep equals', ->
      it 'should be true for matching arrays', ->
        base.current = [
          val: true
          actual: [1,2,3]
        ]
        expect(base.deep.equals([1,2,3]).current[0].val).to.be.true

      it 'should be true for matching objects', ->
        base.current = [
          val: true
          actual:
            foo: 'bar'
        ]
        expect(base.deep.equals(foo: 'bar').current[0].val).to.be.true

      it 'should be true for matching newable objects', ->
        base.current = [
          val: true
          actual: new Date(2000, 9, 9)
        ]
        expect(base.deep.equals(new Date(2000, 9, 9)).current[0].val).to.be.true

  describe '#matches', ->
    it 'should return true on a match', ->
      base.current = [
        val: false
        actual: 'thingy'
      ]
      expect(base.matches(/^thin/).current[0].val).to.be.true

  describe '#a', ->
    it 'should be true for strings', ->
      expect(base.is.a('string').current[0].val).to.be.true

    it 'should be true for arrays', ->
      base.current = [
        val: false
        actual: [1,2,3]
      ]
      expect(base.is.a('array').current[0].val).to.be.true

    it 'should be true for objects', ->
      base.current = [
        val: false
        actual:
          foo: 'bar'
      ]
      expect(base.is.a('object').current[0].val).to.be.true

    it 'should be true for new-able types', ->
      base.current = [
        val: false
        actual: new Date(2000, 9, 9)
      ]
      expect(base.is.a('date').current[0].val).to.be.true

    it 'should be true for custom types', ->
      base.current = [
        val: false
        actual: new (class Thing)()
      ]
      expect(base.is.a('thing').current[0].val).to.be.true

    it 'should be false for different types', ->
      base.current = [
        val: true
        actual: 'something'
      ]
      expect(base.is.a('spaceship').current[0].val).to.be.false

    it 'should be false for null', ->
      base.current = [
        val: true
        actual: null
      ]
      expect(base.is.a('null').current[0].val).to.be.false

    it 'should be false for undefined', ->
      base.current = [
        val: true
        actual: undefined
      ]
      expect(base.is.a('undefined').current[0].val).to.be.false

  describe '#an', ->
    it 'should be true for strings', ->
      expect(base.is.an('string').current[0].val).to.be.true

    it 'should be true for arrays', ->
      base.current = [
        val: false
        actual: [1,2,3]
      ]
      expect(base.is.an('array').current[0].val).to.be.true

    it 'should be true for objects', ->
      base.current = [
        val: false
        actual:
          foo: 'bar'
      ]
      expect(base.is.an('object').current[0].val).to.be.true

    it 'should be true for new-able types', ->
      base.current = [
        val: false
        actual: new Date(2000, 9, 9)
      ]
      expect(base.is.an('date').current[0].val).to.be.true

    it 'should be true for custom types', ->
      base.current = [
        val: false
        actual: new (class Thing)()
      ]
      expect(base.is.an('thing').current[0].val).to.be.true

    it 'should be false for different types', ->
      base.current = [
        val: true
        actual: 'something'
      ]
      expect(base.is.an('spaceship').current[0].val).to.be.false

    it 'should be false for null', ->
      base.current = [
        val: true
        actual: null
      ]
      expect(base.is.an('null').current[0].val).to.be.false

    it 'should be false for undefined', ->
      base.current = [
        val: true
        actual: undefined
      ]
      expect(base.is.an('undefined').current[0].val).to.be.false

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

  describe '#key', ->
    it 'should be true for objects with the key', ->
      base.current = [
        val: false
        actual:
          foo: 'bar'
      ]
      expect(base.has.key('foo').current[0].val).to.be.true

    it 'should be false for objects without the key', ->
      base.current = [
        val: true
        actual:
          foo: 'bar'
      ]
      expect(base.has.key('baz').current[0].val).to.be.false

    it 'should be false for non-objects', ->
      base.current = [
        val: true
        actual: 2
      ]
      expect(base.has.key('baz').current[0].val).to.be.false

  describe '#keys', ->
    it 'should be true for objects with the keys', ->
      base.current = [
        val: false
        actual:
          foo: 'bar'
          hello: 'world'
      ]
      expect(base.has.keys('foo', 'hello').current[0].val).to.be.true

    it 'should be false for objects without the key', ->
      base.current = [
        val: true
        actual:
          foo: 'bar'
          hello: 'world'
      ]
      expect(base.has.keys('baz', 'hello').current[0].val).to.be.false

    it 'should be false for non-objects', ->
      base.current = [
        val: true
        actual: 2
      ]
      expect(base.has.keys('baz').current[0].val).to.be.false

  describe '#value', ->
    it 'should be true for objects with the value', ->
      base.current = [
        val: false
        actual:
          foo: 'bar'
      ]
      expect(base.has.value('bar').current[0].val).to.be.true

    it 'should be false for objects without the value', ->
      base.current = [
        val: true
        actual:
          foo: 'bar'
      ]
      expect(base.has.value('thing').current[0].val).to.be.false

    it 'should be false for other types', ->
      expect(base.has.value('i').current[0].val).to.be.false

  describe '#values', ->
    it 'should be true for objects with the values', ->
      base.current = [
        val: false
        actual:
          foo: 'bar'
          hello: 'world'
      ]
      expect(base.has.values('bar', 'world').current[0].val).to.be.true

    it 'should be false for objects without the values', ->
      base.current = [
        val: true
        actual:
          foo: 'bar'
          hello: 'world'
      ]
      expect(base.has.values('thing', 'world').current[0].val).to.be.false

    it 'should be false for other types', ->
      expect(base.has.values('i').current[0].val).to.be.false

  describe '#defined', ->
    it 'should be false for undefined', ->
      base.current = [
        val: true
        actual: undefined
      ]
      expect(base.is.defined().current[0].val).to.be.false

    it 'should be true for other things', ->
      expect(base.is.defined().current[0].val).to.be.true

  describe '#null', ->
    it 'should be true for null', ->
      base.current = [
        val: false
        actual: null
      ]
      expect(base.is.null().current[0].val).to.be.true

    it 'should be false for other things', ->
      expect(base.is.null().current[0].val).to.be.false

  describe '#true', ->
    it 'should be true for true', ->
      base.current = [
        val: false
        actual: true
      ]
      expect(base.is.true().current[0].val).to.be.true

    it 'should be false for false', ->
      base.current = [
        val: true
        actual: false
      ]
      expect(base.is.true().current[0].val).to.be.false

    it 'should be false for non-booleans', ->
      expect(base.is.true().current[0].val).to.be.false

  describe '#false', ->
    it 'should be true for false', ->
      base.current = [
        val: false
        actual: false
      ]
      expect(base.is.false().current[0].val).to.be.true

    it 'should be false for true', ->
      base.current = [
        val: true
        actual: true
      ]
      expect(base.is.false().current[0].val).to.be.false

    it 'should be false for non-booleans', ->
      expect(base.is.false().current[0].val).to.be.false

  describe '#greaterThan', ->
    it 'should be true for bigger numbers', ->
      base.current = [
        val: false
        actual: 2
      ]
      expect(base.is.greaterThan(1).current[0].val).to.be.true

    it 'should be false for equal numbers', ->
      base.current = [
        val: true
        actual: 2
      ]
      expect(base.is.greaterThan(2).current[0].val).to.be.false

    it 'should be false for smaller numbers', ->
      base.current = [
        val: false
        actual: 2
      ]
      expect(base.is.greaterThan(5).current[0].val).to.be.false

    it 'should be false for non-numbers', ->
      expect(base.is.greaterThan(2).current[0].val).to.be.false

  describe '#lessThan', ->
    it 'should be true for smaller numbers', ->
      base.current = [
        val: false
        actual: 2
      ]
      expect(base.is.lessThan(5).current[0].val).to.be.true

    it 'should be false for equal numbers', ->
      base.current = [
        val: true
        actual: 2
      ]
      expect(base.is.lessThan(2).current[0].val).to.be.false

    it 'should be false for bigger numbers', ->
      base.current = [
        val: false
        actual: 2
      ]
      expect(base.is.lessThan(1).current[0].val).to.be.false

    it 'should be false for non-numbers', ->
      expect(base.is.lessThan(2).current[0].val).to.be.false

  describe '#greaterThanOrEqualTo', ->
    it 'should be true for bigger numbers', ->
      base.current = [
        val: false
        actual: 2
      ]
      expect(base.is.greaterThanOrEqualTo(1).current[0].val).to.be.true

    it 'should be true for equal numbers', ->
      base.current = [
        val: false
        actual: 2
      ]
      expect(base.is.greaterThanOrEqualTo(2).current[0].val).to.be.true

    it 'should be false for smaller numbers', ->
      base.current = [
        val: false
        actual: 2
      ]
      expect(base.is.greaterThanOrEqualTo(5).current[0].val).to.be.false

    it 'should be false for non-numbers', ->
      expect(base.is.greaterThanOrEqualTo(2).current[0].val).to.be.false

  describe '#lessThanOrEqualTo', ->
    it 'should be true for smaller numbers', ->
      base.current = [
        val: false
        actual: 2
      ]
      expect(base.is.lessThanOrEqualTo(5).current[0].val).to.be.true

    it 'should be true for equal numbers', ->
      base.current = [
        val: false
        actual: 2
      ]
      expect(base.is.lessThanOrEqualTo(2).current[0].val).to.be.true

    it 'should be false for smaller numbers', ->
      base.current = [
        val: false
        actual: 2
      ]
      expect(base.is.lessThanOrEqualTo(1).current[0].val).to.be.false

    it 'should be false for non-numbers', ->
      expect(base.is.lessThanOrEqualTo(2).current[0].val).to.be.false

  describe '#not', ->
    it 'should negate strings', ->
      expect(base.should.not.equal(foo: 'bar').current[0].val).to.be.true

    it 'should negate objects', ->
      base.current = [
        val: false
        actual:
          foo: 'bar'
      ]
      expect(base.to.not.equal(foo: 'bar').current[0].val).to.be.true

    it 'should work with deep', ->
      base.current = [
        val: false
        actual:
          some:
            nested:
              obj: ['with', 'an', 'array']
      ]
      expect(base.to.not.deeply.equal
        some:
          nested:
            obj: ['with', 'an', 'array']
      .current[0].val).to.be.false
