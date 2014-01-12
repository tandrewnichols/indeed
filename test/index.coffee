describe 'index', ->
  context 'non-global', ->
    it 'should return all helpers in an object', ->
      lib = require('./../lib')
      lib.should.have.properties('indeed', 'neither', 'either', 'both', 'noneOf', 'allOf', 'oneOf', 'nOf')

  context 'global', ->
    it 'should set global helpers', ->
      require('./../lib')()
      global.indeed.should.be.a.Function
      global.either.should.be.a.Function
      global.neither.should.be.a.Function
      global.both.should.be.a.Function
      global.noneOf.should.be.a.Function
      global.allOf.should.be.a.Function
      global.anyOf.should.be.a.Function
      global.oneOf.should.be.a.Function
      global.nOf.should.be.a.Function
