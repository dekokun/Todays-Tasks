(function() {
  var Todos, db, mongoose, should;

  db = 'mongodb://localhost/test';

  Todos = process.env.TEST_COV ? require("../model-cov/todo").connect(db) : require("../model/todo").connect(db);

  mongoose = require('mongoose');

  should = require("should");

  mongoose.connect(db);

  db = new mongoose.Schema({
    title: String,
    description: String,
    completed: Boolean,
    nice: Number,
    "default": 0
  });

  mongoose.model('Todos', this.db);

  db = mongoose.model('Todos');

  describe("Todos", function() {
    afterEach(function(done) {
      return db.remove({}, function(err) {
        return done(err);
      });
    });
    beforeEach(function(done) {
      return db.remove({}, function(err) {
        return done(err);
      });
    });
    describe("todo_list", function() {
      describe("todoがひとつだけ", function() {
        beforeEach(function(done) {
          return db.remove({}, function() {
            return new db({
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
      return describe("todoが3つ", function() {
        beforeEach(function(done) {
          return db.remove({}, function() {
            return new db({
              title: 'false',
              description: 'fugafuga',
              completed: false
            }).save(function(err) {
              return new db({
                title: 'hogehogetitle',
                description: 'fugafuga',
                completed: true
              }).save(function(err) {
                return new db({
                  title: 'nice',
                  description: 'fugafuga',
                  completed: false,
                  nice: 2
                }).save(function(err) {
                  return done(err);
                });
              });
            });
          });
        });
        it("todosに3個要素があること", function(done) {
          var callback;
          callback = function(err, todos) {
            todos.should.have.length(3);
            return done();
          };
          return Todos.list(callback);
        });
        it("niceが高いものが1番にくること", function(done) {
          var callback;
          callback = function(err, todos) {
            todos[0].title.should.be.equal('nice');
            return done();
          };
          return Todos.list(callback);
        });
        return it("完了していないものが2番にくること", function(done) {
          var callback;
          callback = function(err, todos) {
            todos[1].title.should.be.equal('false');
            return done();
          };
          return Todos.list(callback);
        });
      });
    });
    describe("add_todo", function() {
      it("completedがfalseになっていること", function(done) {
        var callback;
        callback = function(err) {
          return db.findOne({
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
          return db.findOne({
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
          return db.findOne({
            title: 'hoge'
          }, function(err, todo) {
            (todo.nice - 0).should.be.equal(0);
            return done(err);
          });
        };
        return Todos.add_todo('hoge', 'fuga', void 0, callback);
      });
    });
    return describe("removeById", function() {
      var testTodo;
      testTodo = {};
      beforeEach(function(done) {
        return new db({
          title: 'hogehogetitle',
          description: 'fugafuga',
          completed: true
        }).save(function(err) {
          if (err) done(err);
          return db.findOne({
            title: 'hogehogetitle'
          }, function(err, todo) {
            testTodo = todo;
            return done(err);
          });
        });
      });
      return it("削除したものは存在しないこと", function(done) {
        var callback;
        callback = function(err) {
          return db.findOne({
            title: 'hogehogetitle'
          }, function(err, todo) {
            should.not.exist(todo);
            return done(err);
          });
        };
        return Todos.removeById(testTodo._id, callback);
      });
    });
  });

}).call(this);
