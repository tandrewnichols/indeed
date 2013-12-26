describe 'index', ->
  context 'non-global', ->
    it 'should return all helpers in an object', ->
      lib = require('./../lib')
      lib.should.have.properties('neither', 'either', 'both', 'noneOf', 'allOf', 'oneOf', 'nOf')
      lib.should.be.a.Function
  context 'global', ->
    it 'should assign helpers to global', ->
      require('./../lib')()
      neither.should.be.a.Function
      either.should.be.a.Function
      both.should.be.a.Function
      noneOf.should.be.a.Function
      allOf.should.be.a.Function
      oneOf.should.be.a.Function
      nOf.should.be.a.Function
