describe 'noneOf', ->
  it 'should return an object with and', ->
    expect(noneOf(true)).to.be.an.instanceOf(noneOf.NoneOf)
    expect(noneOf(true).and).to.be.a('function')
    expect(noneOf(true).test).to.be.a('function')

  describe '#and', ->
    context 'called with all true', ->
      it 'should return false', ->
        expect(noneOf(true).and(true).and(true).test()).to.be.false
    context 'called with some true', ->
      it 'should return false', ->
        expect(noneOf(true).and(false).and(true).test()).to.be.false
    context 'called with all false', ->
      it 'should return true', ->
        expect(noneOf(false).and(false).and(false).test()).to.be.true

  describe '#And', ->
    it 'should delegate to indeed an and', ->
      expect(noneOf(false).and(false).And.indeed(true).and(false).test()).to.be.false

  describe '#Or', ->
    it 'should delegate to indeed with an or', ->
      expect(noneOf(true).and(false).Or.else(true).or(false).test()).to.be.true

  describe '#Xor', ->
    it 'should delegate to indeed with an xor', ->
      expect(noneOf(true).and(false).Xor.indeed(true).or(false).test()).to.be.true
