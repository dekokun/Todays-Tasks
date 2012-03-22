(function() {
  var Todos, should;

  Todos = require("../model/todo");

  should = require("should");

  describe("Todos", function() {
    return describe("todo", function() {
      beforeEach(function(done) {
        return Todos.remove({}, function() {
          return new Todos({
            title: 'hogehogetitle',
            description: 'fugafuga',
            completed: true
          }).save(function(err) {
            return done(err);
          });
        });
      });
      afterEach(function(done) {
        return Todos.remove({
          title: 'hogehogetitle'
        }, function(err) {
          return done(err);
        });
      });
      it("todosが配列であること", function(done) {
        var callback;
        callback = function(err, todos) {
          todos.should.be.an["instanceof"](Array);
          return done();
        };
        return Todos.list(callback);
      });
      return it("todosに1個だけ要素があること", function(done) {
        var callback;
        callback = function(err, todos) {
          todos.should.have.length(1);
          return done();
        };
        return Todos.list(callback);
      });
    });
  });

}).call(this);
