(function() {
  var Tasks, mongoose;

  mongoose = require('mongoose');

  Tasks = (function() {

    function Tasks(db) {
      mongoose.connect(db);
      this.db = new mongoose.Schema({
        title: String,
        description: String,
        url: String
      });
      mongoose.model('Tasks', this.db);
      this.db = mongoose.model('Tasks');
    }

    Tasks.prototype.add_task = function(req, res, callback) {
      return new this.db({
        title: req.body.title,
        description: req.body.description,
        url: req.body.url
      }).save(function(err) {
        return callback(err);
      });
    };

    Tasks.prototype.del_task = function(req, res, callback) {
      return this.db.remove({
        _id: req.params.id
      }, function(err) {
        return callback(err);
      });
    };

    Tasks.prototype.all_task = function(req, res, callback) {
      return this.db.find({}, function(err, tasks) {
        return callback(err, tasks);
      });
    };

    return Tasks;

  })();

  module.exports.connect = function(db) {
    return new Tasks(db);
  };

}).call(this);
