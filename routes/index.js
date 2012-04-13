(function() {
  var Tasks;

  Tasks = require("../model/task").connect('hoge');

  exports.index = function(req, res) {
    return Tasks.all_task(req, res, function(err, tasks) {
      return res.render('check', {
        tasks: tasks,
        title: 'Todays Tasks'
      });
    });
  };

}).call(this);
