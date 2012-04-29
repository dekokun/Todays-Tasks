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
        "default": 0
      });
      mongoose.model('Todos', this.db);
      this.db = mongoose.model('Todos');
    }

    Todos.prototype.list = function(callback) {
      return this.db.find({}, function(err, todos) {
        todos.sort(function(a, b) {
          if (a.completed) {
            return 1;
          } else {
            return -1;
          }
        });
        return callback(err, todos);
      });
    };

    Todos.prototype.add = function(title, description, completed, callback) {
      if (!completed) completed = false;
      return new this.db({
        title: title,
        description: description,
        completed: completed
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
