(function() {

  exports.todo = function(collection) {
    return function(req, res) {
      return collection.find({}, function(err, todos) {
        todos.sort(function(a, b) {
          return b.nice - a.nice;
        });
        return res.render('todo', {
          todos: todos,
          title: 'TODO'
        });
      });
    };
  };

  exports.add_todo = function(collection) {
    return function(req, res) {
      var completed;
      if (!(completed = req.body.completed)) completed = false;
      return new collection({
        title: req.body.title,
        description: req.body.description,
        completed: completed
      }).save(function(err) {
        return res.redirect('/todo');
      });
    };
  };

  exports.del_todo = function(collection) {
    return function(req, res) {
      console.log(req.params.id);
      return collection.remove({
        _id: req.params.id
      }, function(err) {
        return res.redirect('/todo');
      });
    };
  };

  exports.change_todo = function(collection) {
    return function(req, res) {
      var completed;
      if (req.body.completed === "false" || !req.body.completed) {
        completed = false;
      } else {
        completed = true;
      }
      return collection.update({
        _id: req.params.id
      }, {
        $set: {
          completed: completed
        }
      }, function(err) {
        return res.redirect('/todo');
      });
    };
  };

  exports.nice = function(collection) {
    return function(req, res) {
      return collection.update({
        _id: req.params.id
      }, {
        $inc: {
          nice: 1
        }
      }, function(err) {
        return res.redirect('/todo');
      });
    };
  };

}).call(this);