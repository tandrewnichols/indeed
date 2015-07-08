describe 'allOf', ->
  it 'should return an object with and', ->
    expect(allOf(true)).to.be.an.instanceOf(allOf.AllOf)
    expect(allOf(true).and).to.be.a('function')
    expect(allOf(true).test).to.be.a('function')

  describe '#and', ->
    context 'called with all true', ->
      it 'should return true', ->
        expect(allOf(true).and(true).and(true).test()).to.be.true
    context 'called with some true', ->
      it 'should return false', ->
        expect(allOf(true).and(false).and(true).test()).to.be.false
    context 'called with all false', ->
      it 'should return false', ->
        expect(allOf(false).and(false).and(false).test()).to.be.false

  describe '#And', ->
    it 'should delegate to indeed an and', ->
      expect(allOf(true).and(true).And.indeed(true).and(true).test()).to.be.true

  describe '#Or', ->
    it 'should delegate to indeed with an or', ->
      expect(allOf(true).and(false).Or.else(true).or(false).test()).to.be.true

  describe '#Xor', ->
    it 'should delegate to indeed with an xor', ->
      expect(allOf(true).and(false).Xor.indeed(true).or(false).test()).to.be.true

  describe 'Not', ->
    it 'should negate the next group', ->
      expect(allOf(true).and(true).And.Not.indeed(true).and(true).test()).to.be.false
