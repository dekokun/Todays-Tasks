(function() {

  exports.index = function(req, res) {
    return res.render("index", {
      title: "Todays tasks"
    });
  };

  exports.tasks = function(collection) {
    return function(req, res) {
      return collection.find({}, function(err, tasks) {
        return res.render('tasks', {
          tasks: tasks,
          title: 'Tasks'
        });
      });
    };
  };

  exports.add_task = function(collection) {
    return function(req, res) {
      console.dir(req.body);
      return new collection({
        title: req.body.title,
        description: req.body.description,
        url: req.body.url
      }).save(function(err) {
        return res.redirect('/tasks');
      });
    };
  };

}).call(this);
