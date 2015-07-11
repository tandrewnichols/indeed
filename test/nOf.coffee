describe 'nOf', ->
  it 'should return an object with and', ->
    expect(n(2)).to.be.an.instanceOf(n.NOf)
    expect(n(2).and).to.be.a.Function
    expect(n(2).test).to.be.a.Function
    expect(n(2).of).to.be.a.Function

  describe '#and', ->
    context 'with the right number of trues', ->
      it 'should return true', ->
        expect(n(2).of(true).and(true).and(false).test()).to.be.true
    context 'with the wrong number of trues', ->
      it 'should return false', ->
        expect(n(2).of(true).and(false).and(false).test()).to.be.false

    context 'called multiple times', ->
      expect(( ->
        n(2).of(true).of(false)
      )).to.throw('IllegalMethodException: "of" cannot be called with "of/and"')

  describe '#And', ->
    it 'should delegate to indeed an and', ->
      expect(n(1).of(true).and(true).And.indeed(true).and(true).test()).to.be.false

  describe '#Or', ->
    it 'should delegate to indeed with an or', ->
      expect(n(1).of(true).and(true).Or.else(true).or(false).test()).to.be.true

  describe '#Xor', ->
    it 'should delegate to indeed with an xor', ->
      expect(n(1).of(true).and(true).Xor.indeed(true).or(false).test()).to.be.true
