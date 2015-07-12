describe 'expect', ->
  it 'should initialize values', ->
    expect(xpect(true).previous).to.eql([])
    expect(xpect(true).calls).to.eql(['expect'])
    expect(xpect(true).current).to.eql [
      val: true
      negate: undefined
      actual: true
    ]
    expect(xpect.not(true).current).to.eql [
      val: true
      negate: true
      actual: true
    ]
    expect(xpect.Not(true).flags.groupNot).to.be.true
    expect(xpect.chain(true).flags.chain).to.be.true
    expect(xpect.not.chain(true).current).to.eql [
      val: true
      negate: true
      actual: true
    ]
    expect(xpect.not.chain(true).flags.chain).to.be.true
    expect(xpect.Not.chain(true).flags).to.eql
      not: false
      groupNot: true
      chain: true
      deep: false
      noCase: false

  describe '#new', ->
    context 'with a spy', ->
      it 'should extend expect when called with a spy', ->
        spy = sinon.spy()
        spy('foo')
        expect(xpect(spy).to.have.been.calledWith('foo')).to.be.true
        expect(xpect('thing').calledWith).to.not.be.defined

      it 'should extend expect when called with a stub', ->
        stub = sinon.stub()
        stub('foo')
        expect(xpect(stub).to.have.been.calledWith('foo')).to.be.true

      it 'should allow negation on spy methods and properties', ->
        stub = sinon.stub()
        stub2 = sinon.stub()
        expect(xpect(stub).not.to.have.been.called).to.be.true
        stub('foo')
        expect(xpect(stub).not.to.have.been.calledWith('bar')).to.be.true
        obj = {}
        stub2.apply(obj, ['foo'])
        expect(xpect(stub).not.to.have.been.calledAfter(stub2)).to.be.true
        expect(xpect(stub2).not.to.have.been.calledOn(obj)).to.be.false
        stub({ foo: 'bar', baz: 'quux' })
        expect(xpect(stub).not.to.have.been.calledWithMatch({ foo: 'baz' })).to.be.true
        expect(xpect(stub).not.to.have.been.calledThrice).to.be.true
        expect(xpect(stub).not.to.have.been.calledTwice).to.be.false
        new stub2()
        expect(xpect(stub2).not.to.have.been.calledWithNew()).to.be.false

      it 'should not blow up when called with undefined', ->
        expect(xpect(undefined).calledWith).to.not.be.defined

      it 'should not blow up when called with null', ->
        expect(xpect(null).calledWith).to.not.be.defined

  describe '#throws', ->
    context 'with no args', ->
      it 'should return true when the method throws an exception', ->
        fn = ->
          throw new Error('blah')
        expect(xpect(fn).throws()).to.be.true

      it 'should return true for a matching Error object', ->
        fn = ->
          throw new Error('blah')
        expect(xpect(fn).throw(new Error('blah'))).to.be.true

      it 'should return true for a matching string', ->
        fn = ->
          throw new Error('blah')
        expect(xpect(fn).throw('blah')).to.be.true

      it 'should return true for a matching regex', ->
        fn = ->
          throw new Error('blah')
        expect(xpect(fn).throw(/blah/)).to.be.true

      it 'should return the error for a function', ->
        fn = ->
          throw new Error('blah')
        expect(xpect(fn).throw((e) -> return e.message.indexOf('l') > -1)).to.be.true

      it 'should convert an error string to an error object', ->
        fn = ->
          throw 'blah'
        expect(xpect(fn).throw(new Error('blah'))).to.be.true

      it 'should return false for other types', ->
        fn = ->
          throw 'blah'
        expect(xpect(fn).throw([1,2,3])).to.be.false

      it 'should return false for a non-function', ->
        fn = 'foo'
        expect(xpect(fn).throw('foo')).to.be.false

    context 'with args', ->
      it 'should apply the args to the call', ->
        fn = (args...) ->
          throw new Error(args.join(' '))
        expect(xpect(fn).with('foo', 'bar').throw('foo bar')).to.be.true

    context 'with no error', ->
      it 'should return false', ->
        fn = ->
        expect(xpect(fn).to.throw()).to.be.false

  describe '#assert', ->
    context 'no previous values', ->
      it 'should return basic values', ->
        expect(xpect(true).assert()).to.be.true
        expect(xpect(false).assert()).to.be.false

      it 'should return the value of current', ->
        result = xpect(true)
        expect(result.assert()).to.be.true

      it 'should apply flags.groupNot', ->
        result = xpect(true)
        result.flags.groupNot = true
        expect(result.assert()).to.be.false

    context 'with previous values', ->
      it 'should join all the previous values correctly', ->
        result = xpect(true)
        result.previous = [
            val: true
            join: 'and'
          ,
            val: false
            join: 'or'
        ]
        expect(result.assert()).to.be.true

  describe '#with', ->
    it 'should save off args to use with throw', ->
      fn = ->
      xp = xpect(fn).with('arg', 'foo', ['bar'])
      expect(xp.throwArgs).to.eql ['arg', 'foo', ['bar']]
