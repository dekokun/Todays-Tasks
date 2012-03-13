(function() {
  var Tasks, mongoose;

  mongoose = require('mongoose');

  mongoose.connect('mongodb://localhost/everydaystasks');

  Tasks = new mongoose.Schema({
    title: String,
    description: String,
    url: String
  });

  mongoose.model('Tasks', Tasks);

  Tasks = mongoose.model('Tasks');

  module.exports = Tasks;

}).call(this);
