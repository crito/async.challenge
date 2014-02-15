user = require('../lib/user')

describe 'user lib', ->
  describe 'isOnline', ->
    beforeEach ->
      @stub = sinon.stub(Math, 'random')

    afterEach ->
      @stub.restore()
      
    it 'returns true if the seed is lesser than 0.5', ->
      @stub.returns(0.49)
      expect(user.isOnline()).to.be(true)
      
    it 'returns false if the seed is greater than 0.5', ->
      @stub.returns(0.51)
      expect(user.isOnline()).to.be(false)

    it 'returns false if the seed is 0.5', ->
      @stub.returns(0.5)
      expect(user.isOnline()).to.be(false)
