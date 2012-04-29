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
                  completed: false
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
        return it("完了していないものが2番にくること", function(done) {
          var callback;
          callback = function(err, todos) {
            todos[1].completed.should.be.equal(false);
            return done();
          };
          return Todos.list(callback);
        });
      });
    });
    describe("add", function() {
      return it("completedがfalseになっていること", function(done) {
        var callback;
        callback = function(err) {
          return db.findOne({
            title: 'hoge'
          }, function(err, todo) {
            todo.completed.should.be["false"];
            return done(err);
          });
        };
        return Todos.add('hoge', 'fuga', void 0, callback);
      });
    });
    describe("remove", function() {
      var id;
      id = {};
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
            id = todo._id;
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
        return Todos.remove(id, callback);
      });
    });
    describe("completeChange", function() {
      describe("最初がtrueの時", function() {
        var id;
        id = {};
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
              id = todo._id;
              return done(err);
            });
          });
        });
        it("falseをセットすればfalseになる", function(done) {
          var callback;
          callback = function(err) {
            return db.findOne({
              title: 'hogehogetitle'
            }, function(err, todo) {
              todo.completed.should.be["false"];
              return done(err);
            });
          };
          return Todos.completeChange(id, false, callback);
        });
        return it("trueをセットすればtrueになる", function(done) {
          var callback;
          callback = function(err) {
            return db.findOne({
              title: 'hogehogetitle'
            }, function(err, todo) {
              todo.completed.should.be["true"];
              return done(err);
            });
          };
          return Todos.completeChange(id, true, callback);
        });
      });
      return describe("最初がfalseの時", function() {
        var id;
        id = {};
        beforeEach(function(done) {
          return new db({
            title: 'hogehogetitle',
            description: 'fugafuga',
            completed: false
          }).save(function(err) {
            if (err) done(err);
            return db.findOne({
              title: 'hogehogetitle'
            }, function(err, todo) {
              id = todo._id;
              return done(err);
            });
          });
        });
        it("falseをセットすればfalseになる", function(done) {
          var callback;
          callback = function(err) {
            return db.findOne({
              title: 'hogehogetitle'
            }, function(err, todo) {
              todo.completed.should.be["false"];
              return done(err);
            });
          };
          return Todos.completeChange(id, false, callback);
        });
        return it("trueをセットすればtrueになる", function(done) {
          var callback;
          callback = function(err) {
            return db.findOne({
              title: 'hogehogetitle'
            }, function(err, todo) {
              todo.completed.should.be["true"];
              return done(err);
            });
          };
          return Todos.completeChange(id, true, callback);
        });
      });
    });
    describe("update", function() {
      var id;
      id = {};
      beforeEach(function(done) {
        var beforeTitle;
        beforeTitle = 'title1';
        return new db({
          title: beforeTitle,
          description: 'hogehogedescription',
          completed: true
        }).save(function(err) {
          if (err) done(err);
          return db.findOne({
            title: beforeTitle
          }, function(err, todo) {
            id = todo._id;
            return done(err);
          });
        });
      });
      it("titleが変わっている", function(done) {
        var afterTitle, callback;
        afterTitle = "title2";
        callback = function(err) {
          return db.findOne({
            _id: id
          }, function(err, todo) {
            todo.title.should.be.equal(afterTitle);
            return done(err);
          });
        };
        return Todos.update(id, afterTitle, 'hoge', callback);
      });
      return it("descriptionが変わっている", function(done) {
        var afterDescription, callback;
        afterDescription = "description2";
        callback = function(err) {
          return db.findOne({
            _id: id
          }, function(err, todo) {
            todo.description.should.be.equal(afterDescription);
            return done(err);
          });
        };
        return Todos.update(id, 'hoge', afterDescription, callback);
      });
    });
    return describe("findOne", function() {
      var id, searchTitle;
      id = {};
      searchTitle = 'hogehoge';
      beforeEach(function(done) {
        return new db({
          title: searchTitle
        }).save(function(err) {
          if (err) done(err);
          return new db({
            title: 'hogehogeTitle'
          }).save(function(err) {
            return db.findOne({
              title: searchTitle
            }, function(err, todo) {
              id = todo._id;
              return done(err);
            });
          });
        });
      });
      it("title検索でdb.findOneと同じものが取得できている", function(done) {
        var callback;
        callback = function(err) {
          return db.findOne({
            _id: id
          }, function(err, todo) {
            todo._id.should.be.eql(id);
            return done(err);
          });
        };
        return Todos.findOne({
          title: searchTitle
        }, callback);
      });
      return it("id検索でdb.findOneと同じものが取得できている", function(done) {
        var callback;
        callback = function(err) {
          return db.findOne({
            _id: id
          }, function(err, todo) {
            todo.title.should.be.eql(searchTitle);
            return done(err);
          });
        };
        return Todos.findOne({
          _id: id
        }, callback);
      });
    });
  });

}).call(this);
