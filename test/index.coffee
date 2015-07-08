describe 'index', ->
  context 'non-global', ->
    it 'should return all helpers in an object', ->
      expect(lib).to.have.property('indeed')
      expect(lib).to.have.property('expect')
      expect(lib).to.have.property('neither')
      expect(lib).to.have.property('either')
      expect(lib).to.have.property('both')
      expect(lib).to.have.property('noneOf')
      expect(lib).to.have.property('allOf')
      expect(lib).to.have.property('oneOf')
      expect(lib).to.have.property('n')

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
