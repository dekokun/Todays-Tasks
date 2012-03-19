mongoose = require './db'

Tasks = new mongoose.Schema {title: String, description: String, url: String}
mongoose.model 'Tasks', Tasks
Tasks = mongoose.model 'Tasks'

Tasks.add_task = (req, res, callback) ->
  new Tasks({title: req.body.title, description: req.body.description, url: req.body.url}).save (err) ->
    callback err

Tasks.del_task = (req, res, callback) ->
  Tasks.remove {_id: req.params.id}, (err) ->
    callback err

module.exports = Tasks
