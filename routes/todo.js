(function() {

  exports.todo = function(collection) {
    return function(req, res) {
      return collection.find({}, function(err, todos) {
        todos.sort(function(a, b) {
          var _ref, _ref2;
          a.nice = (_ref = a.nice) != null ? _ref : 0;
          b.nice = (_ref2 = b.nice) != null ? _ref2 : 0;
          if (a.completed === b.completed) {
            console.log(b_nice - a_nice);
            return b_nice - a_nice;
          } else if (a.completed) {
            return 1;
          } else {
            return -1;
          }
        });
        return res.render('todo', {
          todos: todos,
          title: 'TODO'
        });
      });
    };
  };

  exports.add = function(collection) {
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

  exports.del = function(collection) {
    return function(req, res) {
      console.log(req.params.id);
      return collection.remove({
        _id: req.params.id
      }, function(err) {
        return res.redirect('/todo');
      });
    };
  };

  exports.change = function(collection) {
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
