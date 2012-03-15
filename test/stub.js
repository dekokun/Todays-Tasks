(function() {
  var a, should, sinon;

  sinon = require("sinon");

  should = require("should");

  a = {};

  a.test = function() {
    return [1, 2];
  };

  describe("stub", function() {
    return describe("stub has all spies API", function() {
      beforeEach(function() {
        return sinon.stub(a, "test");
      });
      afterEach(function() {
        return a.test.restore();
      });
      it("called", function() {
        var callback;
        callback = sinon.spy();
        callback();
        return callback.called.should["true"];
      });
      it("calledWith", function() {
        a.test("hoge");
        return a.test.calledWith("hoge").should["true"];
      });
      it("calledWith two operator", function() {
        a.test("gero", "roro");
        return a.test.calledWith("gero", "roro").should["true"];
      });
      it("callCount", function() {
        a.test("gero", "roro");
        return a.test.callCount.should.equal(1);
      });
      it("withArgs", function() {
        a.test("gero", "roro");
        return a.test.withArgs("gero", "roro").callCount.should.equal(1);
      });
      it("notCaldWith", function() {
        a.test("gege", "gogo");
        a.test("gege", "gogo");
        return a.test.neverCalledWith("gero", "roro").should["true"];
      });
      return it("getCall", function() {
        var spyCall;
        a.test("gege", "gogo");
        a.test("1", "2");
        spyCall = a.test.getCall(1);
        return spyCall.calledWith("1", "2").should["true"];
      });
    });
  });

}).call(this);
