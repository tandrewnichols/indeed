either = require('./../lib/either')

describe 'either', ->
  it 'should return an object with or', ->
    either(true).should.be.an.Object
    either(true).or.should.be.a.Function

  describe 'or', ->
    context 'both true', ->
      it 'should return true', ->
        either(true).or(true).should.be.true
    context 'the first true', ->
      it 'should return true', ->
        either(true).or(false).should.be.true
    context 'the second true', ->
      it 'should return true', ->
        either(false).or(true).should.be.true
    context 'both false', ->
      it 'should return false', ->
        either(false).or(false).should.be.false
