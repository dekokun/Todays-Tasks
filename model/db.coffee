mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/everydaystasks'

module.exports = mongoose
