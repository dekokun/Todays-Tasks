(function() {
  var Todos, markdown;

  Todos = require("../model/todo").connect('mongodb://localhost/everydaystasks');

  markdown = require("markdown").markdown;

  exports.todo = function(req, res) {
    return Todos.list(function(err, todos) {
      var todo;
      todos = (function() {
        var _i, _len, _results;
        _results = [];
        for (_i = 0, _len = todos.length; _i < _len; _i++) {
          todo = todos[_i];
          todo["markdown"] = markdown.toHTML(todo.description);
          _results.push(todo);
        }
        return _results;
      })();
      return res.render('todo', {
        todos: todos,
        title: 'TODO'
      });
    });
  };

  exports.add = function(req, res) {
    return Todos.add(req.body.title, req.body.description, req.body.completed, function(err) {
      return res.redirect('/todo');
    });
  };

  exports.del = function(req, res) {
    req.flash('alert-info', '削除しました');
    return Todos.remove(req.params.id, function(err) {
      return res.redirect('/todo');
    });
  };

  exports.completeChange = function(req, res) {
    var completed;
    if (req.body.completed === "false" || !req.body.completed) {
      completed = false;
    } else {
      completed = true;
    }
    return Todos.completeChange(req.params.id, completed, function(err) {
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

  exports.edit = function(req, res) {
    return Todos.findOne({
      _id: req.params.id
    }, function(err, todo) {
      return res.render('todoEdit', {
        todo: todo,
        title: 'edit'
      });
    });
  };

  exports.update = function(req, res) {
    return Todos.update(req.params.id, req.body.title, req.body.description, function(err) {
      return res.redirect('/todo');
    });
  };

}).call(this);
