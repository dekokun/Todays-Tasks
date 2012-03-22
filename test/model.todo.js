(function() {
  var Todos, should;

  Todos = require("../model/todo");

  should = require("should");

  describe("Todos", function() {
    afterEach(function(done) {
      return Todos.remove({}, function(err) {
        return done(err);
      });
    });
    describe("todo", function() {
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
    return describe("add_todo", function() {
      it("completedがfalseになっていること", function(done) {
        var callback;
        callback = function(err) {
          return Todos.findOne({
            title: 'hoge'
          }, function(err, todo) {
            todo.completed.should.be["false"];
            return done(err);
          });
        };
        return Todos.add_todo('hoge', 'fuga', void 0, callback);
      });
      it("niceが存在すること", function(done) {
        var callback;
        callback = function(err) {
          return Todos.findOne({
            title: 'hoge'
          }, function(err, todo) {
            todo.nice.should.be.exist;
            return done(err);
          });
        };
        return Todos.add_todo('hoge', 'fuga', void 0, callback);
      });
      return it("niceの値が0であること", function(done) {
        var callback;
        callback = function(err) {
          return Todos.findOne({
            title: 'hoge'
          }, function(err, todo) {
            (todo.nice - 0).should.be.equal(0);
            return done(err);
          });
        };
        return Todos.add_todo('hoge', 'fuga', void 0, callback);
      });
    });
  });

}).call(this);
