(function() {

  exports.index = function(collection) {
    return function(req, res) {
      return collection.find({}, function(err, tasks) {
        return res.render('check', {
          tasks: tasks,
          title: 'Todays Tasks'
        });
      });
    };
  };

}).call(this);
