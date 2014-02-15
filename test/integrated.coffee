sinon = require('sinon')
require('./../lib')()
expect = require('chai').expect
xpect = require('./../lib').expect

describe 'integration', ->
  it 'should work as expected', ->
    expect(indeed(true).and(false).Or.else(true).or(false).test()).to.be.true
    expect(neither(false).nor(false).And.neither(true).nor(false).test()).to.be.false
    expect(either(true).or(false).And.both(true).and(true).Xor.noneOf(true).and(false).and(true).test()).to.be.true
    expect(both(true).and(true).And.allOf(true).and(false).and(false).Or.else(true).and(false).test()).to.be.false
    expect(indeed.not(true).andNot(false).Or.either(true).or(false).test()).to.be.true
    
  it 'should allow and/or/etc with comparisons', ->
    expect(indeed('hello').is.a('string').and(4).is.gt(2).test()).to.be.true
    expect(indeed([1,2]).contains(3).and('foo').equals('foo').And.also(foo: 'bar').containsValue('bar').and(undefined).is.defined().test()).to.be.false

  it 'should allow comparisons with all entry points', ->
    expect(neither(3).is.lt(2).nor(foo: 'bar').containsKey('baz').test()).to.be.true
    expect(either(null).is.null().or(false).is.true().test()).to.be.true
    expect(allOf('hello').equals('hello').and(foo: 'bar').is.an('object').and(3).is.gte(3).test()).to.be.true
    expect(anyOf(1).equals(2).and([2,3]).contains(1).and(undefined).is.defined().test()).to.be.false
    expect(both(foo: 'bar').containsValue('bar').and(3).is.null().test()).to.be.false
    expect(n(2).of('a').is.a('string').and(new Date(2000, 9, 9)).deep.equals(new Date(2000, 9, 9)).and('hello world').contains('foo').test()).to.be.true
    expect(noneOf(2).is.lte(1).and([1,2,3]).is.an('array').and(true).is.false().test()).to.be.false
    expect(oneOf(2).is.lte(1).and([1,2,3]).is.an('object').and(true).is.true().test()).to.be.true

  it 'should allow mixin methods on all entry points', ->
    indeed.mixin
      can: (condition) ->
        return (val) -> typeof val[condition] == 'function'
      hasLength: (condition) ->
        return (val) -> typeof val != 'undefined' && typeof val.length != 'undefined'
    expect(neither(false).nor(foo: ->).can('foo').test()).to.be.false
    expect(either(false).or(foo: ->).can('bar').test()).to.be.false
    expect(allOf(true).and(true).and('string').hasLength().test()).to.be.true
    expect(anyOf(false).and(false).and([1,2]).hasLength().test()).to.be.true
    expect(both(true).and(foo: 'bar').hasLength().test()).to.be.false
    expect(n(2).of(true).and(false).and(foo: ->).can('foo').test()).to.be.true
    expect(noneOf(false).and(false).and(1).can('foo').test()).to.be.true
    expect(oneOf(false).and(false).and('').hasLength().test()).to.be.true

  it 'should allow comparisons followed by joins', ->
    expect(either(2).is.lt(1).or('string').is.an('object').Or.else(true).is.false().test()).to.be.false
    expect(neither(false).nor('string').equals(3).And.either(3).is.gte(3).or([1,2]).contains(4).test()).to.be.true

  it 'should allow multiple comparisons?', ->
    expect(indeed(foo: 'bar').to.be.an('object').andTo.have.property('foo').andTo.have.value('bar').test()).to.be.true
    expect(xpect([1,2,3]).to.contain(3).andTo.be.an('array').test()).to.be.true
