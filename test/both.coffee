describe 'both', ->
  it 'should return an object with and', ->
    expect(both(true)).to.be.an.instanceOf(both.Both)
    expect(both(true).and).to.be.a('function')
    expect(both(true).test).to.be.a('function')

  describe '#and', ->
    context 'both true', ->
      it 'should return true', ->
        expect(both(true).and(true)).to.be.true
    context 'one true', ->
      it 'should return false', ->
        expect(both(true).and(false)).to.be.false
    context 'both false', ->
      it 'should return false', ->
        expect(both(false).and(false)).to.be.false

    context 'called with errors', ->
      it 'should throw IllegalMethodException when chaining', ->
        expect((->
          both.chain(true).and(true).and(true)
        )).to.throw('IllegalMethodException: and cannot be called with both/and')

      it 'should throw Object false has no method when not chaining', ->
        expect(( ->
          both(true).and(true).and(true)
        )).to.throw('Object true has no method \'and\'')

  describe '#And', ->
    it 'should delegate to indeed an and', ->
      expect(both.chain(true).and(true).And.indeed(true).and(true).test()).to.be.true

  describe '#Or', ->
    it 'should delegate to indeed with an or', ->
      expect(both.chain(true).and(false).Or.else(true).or(false).test()).to.be.true

  describe '#Xor', ->
    it 'should delegate to indeed with an xor', ->
      expect(both.chain(true).and(false).Xor.indeed(true).or(false).test()).to.be.true
