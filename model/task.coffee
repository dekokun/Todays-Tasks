mongoose = require './db'

Tasks = new mongoose.Schema {title: String, description: String, url: String}
mongoose.model 'Tasks', Tasks
Tasks = mongoose.model 'Tasks'

module.exports = Tasks
