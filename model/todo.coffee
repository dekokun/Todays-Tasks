mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/everydaystasks'

Todos = new mongoose.Schema {title: String, description: String, completed: Boolean, nice: Number, default: 0}
mongoose.model 'Todos', Todos
Todos = mongoose.model 'Todos'

module.exports = Todos
