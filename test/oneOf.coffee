oneOf = require('./../lib/oneOf')

describe 'oneOf', ->
  it 'should return an object with and', ->
    oneOf(true).should.be.an.Object
    oneOf(true).and.should.be.a.Function
    oneOf(true).test.should.be.a.Function
    oneOf.reset.should.be.a.Function
