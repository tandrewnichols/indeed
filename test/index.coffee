describe 'index', ->
  context 'non-global', ->
    it 'should return all helpers in an object', ->
      lib = require('./../lib')
      lib.should.have.properties('indeed', 'neither', 'either', 'both', 'noneOf', 'allOf', 'oneOf', 'nOf')
