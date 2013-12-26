both = require('./../lib/both')

describe 'both', ->
  it 'should return an object with and', ->
    both(true).should.be.an.Object
    both(true).and.should.be.a.Function

  describe 'and', ->
    context 'both true', ->
      it 'should return true', ->
        both(true).and(true).should.be.true
    context 'one true', ->
      it 'should return false', ->
        both(true).and(false).should.be.false
    context 'both false', ->
      it 'should return false', ->
        both(false).and(false).should.be.false
