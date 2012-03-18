(function() {
  var Tasks;

  Tasks = require("../model/task");

  exports.index = function(req, res) {
    return collection.find({}, function(err, tasks) {
      return res.render('check', {
        tasks: tasks,
        title: 'Todays Tasks'
      });
    });
  };

}).call(this);
