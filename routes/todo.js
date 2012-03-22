(function() {
  var Todos;

  Todos = require("../model/todo");

  exports.todo = function(req, res) {
    return Todos.list(function(err, todos) {
      return res.render('todo', {
        todos: todos,
        title: 'TODO'
      });
    });
  };

  exports.add = function(req, res) {
    var completed;
    if (!(completed = req.body.completed)) completed = false;
    return new Todos({
      title: req.body.title,
      description: req.body.description,
      completed: completed
    }).save(function(err) {
      return res.redirect('/todo');
    });
  };

  exports.del = function(req, res) {
    req.flash('alert-info', '削除しました');
    return Todos.remove({
      _id: req.params.id
    }, function(err) {
      return res.redirect('/todo');
    });
  };

  exports.change = function(req, res) {
    var completed;
    if (req.body.completed === "false" || !req.body.completed) {
      completed = false;
    } else {
      completed = true;
    }
    return Todos.update({
      _id: req.params.id
    }, {
      $set: {
        completed: completed
      }
    }, function(err) {
      return res.redirect('/todo');
    });
  };

  exports.nice = function(req, res) {
    return Todos.update({
      _id: req.params.id
    }, {
      $inc: {
        nice: 1
      }
    }, function(err) {
      return res.redirect('/todo');
    });
  };

}).call(this);
