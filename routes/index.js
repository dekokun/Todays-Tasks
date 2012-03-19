(function() {
  var Tasks;

  Tasks = require("../model/task");

  exports.index = function(req, res) {
    return Tasks.find({}, function(err, tasks) {
      return res.render('check', {
        tasks: tasks,
        title: 'Todays Tasks'
      });
    });
  };

}).call(this);
