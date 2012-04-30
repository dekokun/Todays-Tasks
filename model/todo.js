(function() {
  var Todos, async, mongoose;

  mongoose = require('mongoose');

  async = require('async');

  Todos = (function() {

    function Todos(db) {
      mongoose.connect(db);
      this.db = new mongoose.Schema({
        title: String,
        description: String,
        completed: Boolean,
        parent: String,
        isTop: {
          type: Boolean,
          "default": false
        }
      });
      mongoose.model('Todos', this.db);
      this.db = mongoose.model('Todos');
    }

    Todos.prototype.list = function(callback) {
      var db, todoSort;
      todoSort = function(todos) {
        return todos.sort(function(a, b) {
          if (a.completed) {
            return 1;
          } else {
            return -1;
          }
        });
      };
      db = this.db;
      return db.find({
        isTop: true
      }, function(err, parents) {
        var func, myfunc, parent, _i, _len;
        func = [];
        myfunc = function(todo) {
          return function(callback) {
            return db.find({
              parent: todo._id
            }, function(err, children) {
              todoSort(children);
              todo.todos = children;
              return callback(err, todo);
            });
          };
        };
        for (_i = 0, _len = parents.length; _i < _len; _i++) {
          parent = parents[_i];
          func.push(myfunc(parent));
        }
        return async.parallel(func, function(err, results) {
          todoSort(results);
          return callback(err, results);
        });
      });
    };

    Todos.prototype.add = function(title, description, completed, parent, callback) {
      var isTop;
      isTop = true;
      if (parent != null) isTop = false;
      if (!completed) completed = false;
      return new this.db({
        title: title,
        description: description,
        completed: completed,
        isTop: isTop,
        parent: parent
      }).save(function(err) {
        return callback(err);
      });
    };

    Todos.prototype.update = function(id, title, description, callback) {
      return this.db.update({
        _id: id
      }, {
        $set: {
          title: title,
          description: description
        }
      }, function(err) {
        return callback(err);
      });
    };

    Todos.prototype.completeChange = function(id, completed, callback) {
      return this.db.update({
        _id: id
      }, {
        $set: {
          completed: completed
        }
      }, function(err) {
        return callback(err);
      });
    };

    Todos.prototype.remove = function(id, callback) {
      return this.db.remove({
        _id: id
      }, function(err) {
        return callback(err);
      });
    };

    Todos.prototype.findOne = function(obj, callback) {
      return this.db.findOne(obj, callback);
    };

    return Todos;

  })();

  module.exports.connect = function(db) {
    return new Todos(db);
  };

}).call(this);
