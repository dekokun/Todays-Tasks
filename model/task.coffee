mongoose = require 'mongoose'

class Tasks
  constructor: (db) ->
    mongoose.connect db


    @db = new mongoose.Schema {
        title: String
      , description: String
      , url: String
    }

    mongoose.model 'Tasks', @db
    @db = mongoose.model 'Tasks'

  add_task: (req, res, callback) ->
    new @db({title: req.body.title, description: req.body.description, url: req.body.url}).save (err) ->
      callback err

  del_task: (req, res, callback) ->
    @db.remove {_id: req.params.id}, (err) ->
      callback err

  all_task: (req, res, callback) ->
    @db.find {}, (err, tasks) ->
      callback err, tasks

module.exports.connect = (db) ->
  new Tasks(db)
