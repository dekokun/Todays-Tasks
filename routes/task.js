(function() {

  exports.tasks = function(collection) {
    return function(req, res) {
      return collection.find({}, function(err, tasks) {
        return res.render('task', {
          tasks: tasks,
          title: 'Tasks'
        });
      });
    };
  };

  exports.add = function(collection) {
    return function(req, res) {
      return new collection({
        title: req.body.title,
        description: req.body.description,
        url: req.body.url
      }).save(function(err) {
        return res.redirect('/task');
      });
    };
  };

  exports.del = function(collection) {
    return function(req, res) {
      req.flash('alert-info', '削除しました');
      console.log(req.params.id);
      return collection.remove({
        _id: req.params.id
      }, function(err) {
        return res.redirect('/task');
      });
    };
  };

}).call(this);
