require('./../lib')()

describe 'integration', ->
  it 'should work as expected', ->
    indeed(true).and(false).Or.else(true).or(false).test().should.be.true
    neither(false).nor(false).And.neither(true).nor(false).test().should.be.false
    either(true).or(false).And.both(true).and(true).Xor.noneOf(true).and(false).and(true).test().should.be.true
    both(true).and(true).And.allOf(true).and(false).and(false).Or.else(true).and(false).test().should.be.false
    indeed.not(true).andNot(false).Or.either(true).or(false).test().should.be.true
    
  it 'should allow and/or/etc with comparisons', ->
    indeed('hello').isA('string').and(4).isGt(2).test().should.be.true
    indeed([1,2]).contains(3).and('foo').is('foo').And.also(foo: 'bar').containsValue('bar').and(undefined).isDefined().test().should.be.false

  it 'should allow comparisons with all entry points', ->
    neither(3).isLt(2).nor(foo: 'bar').containsKey('baz').test().should.be.true
    either(null).isNull().or(false).isTrue().test().should.be.true
    allOf('hello').is('hello').and(foo: 'bar').isAn('object').and(3).isGte(3).test().should.be.true
    anyOf(1).equals(2).and([2,3]).contains(1).and(undefined).isDefined().test().should.be.false
    both(foo: 'bar').containsValue('bar').and(3).isNull().test().should.be.false
    n(2).of('a').isA('string').and(new Date(2000, 9, 9)).equals(new Date(2000, 9, 9)).and('hello world').contains('foo').test().should.be.true
    noneOf(2).isLte(1).and([1,2,3]).isAn('array').and(true).isFalse().test().should.be.false
    oneOf(2).isLte(1).and([1,2,3]).isAn('object').and(true).isTrue().test().should.be.true

  it 'should allow mixin methods on all entry points', ->
    indeed.mixin
      can: (condition) ->
        return (val) -> typeof val[condition] == 'function'
      hasLength: (condition) ->
        return (val) -> typeof val != 'undefined' && typeof val.length != 'undefined'
    neither(false).nor(foo: ->).can('foo').test().should.be.false
    either(false).or(foo: ->).can('bar').test().should.be.false
    allOf(true).and(true).and('string').hasLength().test().should.be.true
    anyOf(false).and(false).and([1,2]).hasLength().test().should.be.true
    both(true).and(foo: 'bar').hasLength().test().should.be.false
    n(2).of(true).and(false).and(foo: ->).can('foo').test().should.be.true
    noneOf(false).and(false).and(1).can('foo').test().should.be.true
    oneOf(false).and(false).and('').hasLength().test().should.be.true

  it 'should allow comparisons followed by joins', ->
    either(2).isLt(1).or('string').isAn('object').Or.else(true).isFalse().test().should.be.false
    neither(false).nor('string').equals(3).And.either(3).isGte(3).or([1,2]).contains(4).test().should.be.true
