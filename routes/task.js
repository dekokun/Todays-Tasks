(function() {
  var Tasks;

  Tasks = require("../model/task");

  exports.tasks = function(req, res) {
    return Tasks.find({}, function(err, tasks) {
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
    console.log(req.params.id);
    return Tasks.del_task(req, res, function(err) {
      return res.redirect('/task');
    });
  };

}).call(this);
