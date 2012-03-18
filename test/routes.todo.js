(function() {
  var Todos, routes, should;

  routes = require("../routes/todo");

  should = require("should");

  Todos = require("../model/todo");

  describe("routes", function() {
    var req, res;
    req = {
      params: {},
      body: {}
    };
    res = {
      redirect: function(route) {},
      render: function(view, vars) {}
    };
    return describe("todo", function() {
      beforeEach(function(done) {
        return new Todos({
          title: 'hogehogetitle',
          description: 'fugafuga',
          completed: true
        }).save(function(err) {
          return done(err);
        });
      });
      afterEach(function(done) {
        return Todos.remove({
          title: 'hogehogetitle'
        }, function(err) {
          return done(err);
        });
      });
      return it("todosが配列であること", function(done) {
        res.render = function(view, vars) {
          vars.todos.should.be.an["instanceof"](Array);
          return done();
        };
        return routes.todo(req, res);
      });
    });
  });

}).call(this);
