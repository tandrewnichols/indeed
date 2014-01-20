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
