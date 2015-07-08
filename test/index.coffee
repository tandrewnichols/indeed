describe 'index', ->
  context 'non-global', ->
    it 'should return all helpers in an object', ->
      expect(_indeed).to.have.property('indeed')
      expect(_indeed).to.have.property('expect')
      expect(_indeed).to.have.property('neither')
      expect(_indeed).to.have.property('either')
      expect(_indeed).to.have.property('both')
      expect(_indeed).to.have.property('noneOf')
      expect(_indeed).to.have.property('allOf')
      expect(_indeed).to.have.property('oneOf')
      expect(_indeed).to.have.property('n')

  context 'global', ->
    it 'should set global helpers', ->
      root = if typeof window == 'object' then window else global
      expect(root.indeed).to.be.a('function')
      expect(root.expect).to.be.a('function')
      expect(root.either).to.be.a('function')
      expect(root.neither).to.be.a('function')
      expect(root.both).to.be.a('function')
      expect(root.noneOf).to.be.a('function')
      expect(root.allOf).to.be.a('function')
      expect(root.anyOf).to.be.a('function')
      expect(root.oneOf).to.be.a('function')
      expect(root.n).to.be.a('function')
