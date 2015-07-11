describe 'neither', ->
  it 'should accept a boolean and return an object with nor', ->
    expect(neither(true)).to.be.an.instanceOf(neither.Neither)
    expect(neither(true).nor).to.be.a('function')
    expect(neither(true).test).to.be.a('function')

  describe '#nor', ->
    context 'both are false', ->
      it 'should return true', ->
        expect(neither(false).nor(false)).to.be.true
    context 'one is false', ->
      it 'should return false', ->
        expect(neither(false).nor(true)).to.be.false
    context 'both are true', ->
      it 'should return false', ->
        expect(neither(true).nor(true)).to.be.false

    context 'called with errors', ->
      it 'should throw IllegalMethodException when chaining', ->
        expect(( ->
          neither.chain(true).nor(true).nor(true)
        )).to.throw('IllegalMethodException: "nor" cannot be called with "neither/nor"')

      it 'should throw Object has no method when not chaining', ->
        expect(( ->
          neither(true).nor(true).nor(true)
        )).to.throw()

  describe '#And', ->
    it 'should delegate to indeed an and', ->
      expect(neither.chain(true).nor(false).And.indeed(true).and(true).test()).to.be.false

  describe '#Or', ->
    it 'should delegate to indeed with an or', ->
      expect(neither.chain(true).nor(false).Or.else(true).or(false).test()).to.be.true

  describe '#Xor', ->
    it 'should delegate to indeed with an xor', ->
      expect(neither.chain(true).nor(false).Xor.indeed(true).or(false).test()).to.be.true
