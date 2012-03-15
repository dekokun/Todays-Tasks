sinon = require("sinon")
should = require("should")
a = {}
a.test = () ->
  [1, 2]

describe "stub", ->
  describe "stub has all spies API", ->
    beforeEach ->
      sinon.stub(a, "test")
    afterEach ->
      a.test.restore()

    it "called", ->
      callback = sinon.spy()
      callback()
      callback.called.should.true

    it "calledWith", ->
      a.test("hoge")
      a.test.calledWith("hoge").should.true

    it "calledWith two operator", ->
      a.test("gero", "roro")
      a.test.calledWith("gero", "roro").should.true

    it "callCount", ->
      a.test("gero", "roro")
      a.test.callCount.should.equal(1)

    it "withArgs", ->
      a.test("gero", "roro")
      a.test.withArgs("gero", "roro").callCount.should.equal(1)

    it "notCaldWith", ->
      a.test("gege", "gogo")
      a.test("gege", "gogo")
      a.test.neverCalledWith("gero", "roro").should.true

    it "getCall", ->
      a.test("gege", "gogo")
      a.test("1", "2")
      spyCall = a.test.getCall(1)
      spyCall.calledWith("1", "2").should.true

