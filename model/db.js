(function() {
  var mongoose;

  mongoose = require('mongoose');

  mongoose.connect('mongodb://localhost/everydaystasks');

  module.exports = mongoose;

}).call(this);
