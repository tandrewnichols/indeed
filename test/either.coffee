describe 'either', ->
  it 'should return an object with or', ->
    expect(either(true)).to.be.an.instanceOf(either.Either)
    expect(either(true).or).to.be.a('function')
    expect(either(true).test).to.be.a('function')

  describe 'or', ->
    context 'both true', ->
      it 'should return true', ->
        expect(either(true).or(true)).to.be.true
    context 'the first true', ->
      it 'should return true', ->
        expect(either(true).or(false)).to.be.true
    context 'the second true', ->
      it 'should return true', ->
        expect(either(false).or(true)).to.be.true
    context 'both false', ->
      it 'should return false', ->
        expect(either(false).or(false)).to.be.false

    context 'called with errors', ->
      it 'should throw IllegalMethodException when chaining', ->
        expect(( ->
          either.chain(true).or(true).or(true)
        )).to.throw('IllegalMethodException: "or" cannot be called with "either/or"')

      it 'should throw Object has no method when not chaining', ->
        expect(( ->
          either(true).or(true).or(true)
        )).to.throw()

  describe '#And', ->
    it 'should delegate to indeed an and', ->
      expect(either.chain(true).or(false).And.indeed(true).and(true).test()).to.be.true

  describe '#Or', ->
    it 'should delegate to indeed with an or', ->
      expect(either.chain(true).or(false).Or.else(true).or(false).test()).to.be.true

  describe '#Xor', ->
    it 'should delegate to indeed with an xor', ->
      expect(either.chain(true).or(false).Xor.indeed(true).or(false).test()).to.be.false
