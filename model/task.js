(function() {
  var Tasks, mongoose;

  mongoose = require('./db');

  Tasks = new mongoose.Schema({
    title: String,
    description: String,
    url: String
  });

  mongoose.model('Tasks', Tasks);

  Tasks = mongoose.model('Tasks');

  Tasks.add_task = function(req, res, callback) {
    return new Tasks({
      title: req.body.title,
      description: req.body.description,
      url: req.body.url
    }).save(function(err) {
      return callback(err);
    });
  };

  Tasks.del_task = function(req, res, callback) {
    return Tasks.remove({
      _id: req.params.id
    }, function(err) {
      return callback(err);
    });
  };

  module.exports = Tasks;

}).call(this);
