(function() {
  var Tasks;

  Tasks = require("../model/task").connect('mongodb://localhost/everydaystasks');

  exports.tasks = function(req, res) {
    return Tasks.all_task(req, res, function(err, tasks) {
      return res.render('task', {
        tasks: tasks,
        title: 'Tasks'
      });
    });
  };

  exports.add = function(req, res) {
    return Tasks.add_task(req, res, function(err) {
      return res.redirect('/task');
    });
  };

  exports.del = function(req, res) {
    req.flash('alert-info', '削除しました');
    return Tasks.del_task(req, res, function(err) {
      return res.redirect('/task');
    });
  };

}).call(this);
