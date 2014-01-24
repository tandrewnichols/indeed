Base = require('./../lib/base')
base = new Base()
sinon = require('sinon')

describe 'base', ->
  describe 'grouping methods', ->
    beforeEach ->
      base.test = sinon.stub().returns(true)
      base.previous = []

    describe '#And', ->
      it 'should add "and" to previous', ->
        base.And.previous.should.eql [
          val: true
          join: 'and'
        ]

      it 'should reset calls', ->
        base.And.calls.should.eql []

    describe '#But', ->
      it 'should add "and" to previous', ->
        base.But.previous.should.eql [
          val: true
          join: 'and'
        ]

      it 'should reset calls', ->
        base.But.calls.should.eql []

    describe '#Or', ->
      it 'should add "or" to previous', ->
        base.Or.previous.should.eql [
          val: true
          join: 'or'
        ]

      it 'should reset calls', ->
        base.Or.calls.should.eql []

    describe '#Xor', ->
      it 'should add "xor" to previous', ->
        base.Xor.previous.should.eql [
          val: true
          join: 'xor'
        ]

      it 'should reset calls', ->
        base.Xor.calls.should.eql []

    describe '#Not', ->
      it 'should negate the group', ->
        base.Not.groupNegate.should.be.true

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
        val: true
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
