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
    return new Tasks({
      title: req.body.title,
      description: req.body.description,
      url: req.body.url
    }).save(function(err) {
      return res.redirect('/task');
    });
  };

  exports.del = function(req, res) {
    req.flash('alert-info', '削除しました');
    console.log(req.params.id);
    return Tasks.remove({
      _id: req.params.id
    }, function(err) {
      return res.redirect('/task');
    });
  };

}).call(this);
