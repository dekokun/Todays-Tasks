(function() {
  var Todos, mongoose;

  mongoose = require('./db');

  Todos = new mongoose.Schema({
    title: String,
    description: String,
    completed: Boolean,
    nice: Number,
    "default": 0
  });

  mongoose.model('Todos', Todos);

  Todos = mongoose.model('Todos');

  Todos.list = function(callback) {
    return this.find({}, function(err, todos) {
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

  module.exports = Todos;

}).call(this);
