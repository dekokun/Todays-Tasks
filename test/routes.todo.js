(function() {
  var db, mongoose, routes, should;

  db = 'mongodb://localhost/test';

  mongoose = require('mongoose');

  routes = require("../routes/todo");

  should = require("should");

  mongoose.connect(db);

  db = new mongoose.Schema({
    title: String,
    description: String,
    completed: Boolean,
    nice: Number,
    "default": 0
  });

  mongoose.model('Todos', db);

  db = mongoose.model('Todos');

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
        return new db({
          title: 'hogehogetitle',
          description: 'fugafuga',
          completed: true
        }).save(function(err) {
          return done(err);
        });
      });
      afterEach(function(done) {
        return db.remove({
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
