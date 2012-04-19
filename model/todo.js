(function() {
  var Todos, mongoose;

  mongoose = require('mongoose');

  Todos = (function() {

    function Todos(db) {
      mongoose.connect(db);
      this.db = new mongoose.Schema({
        title: String,
        description: String,
        completed: Boolean,
        nice: Number,
        "default": 0
      });
      mongoose.model('Todos', this.db);
      this.db = mongoose.model('Todos');
    }

    Todos.prototype.list = function(callback) {
      return this.db.find({}, function(err, todos) {
        todos.sort(function(a, b) {
          var _ref, _ref2;
          a.nice = (_ref = a.nice) != null ? _ref : 0;
          b.nice = (_ref2 = b.nice) != null ? _ref2 : 0;
          if (a.completed === b.completed) {
            return b.nice - a.nice;
          } else if (a.completed) {
            return 1;
          } else {
            return -1;
          }
        });
        return callback(err, todos);
      });
    };

    Todos.prototype.add_todo = function(title, description, completed, callback) {
      if (!completed) completed = false;
      return new this.db({
        title: title,
        description: description,
        completed: completed,
        nice: 0
      }).save(function(err) {
        return callback(err);
      });
    };

    Todos.prototype.completed_change = function(id, completed, callback) {
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

    Todos.prototype.removeById = function(id, callback) {
      return this.db.remove({
        _id: id
      }, function(err) {
        return callback(err);
      });
    };

    return Todos;

  })();

  module.exports.connect = function(db) {
    return new Todos(db);
  };

}).call(this);
