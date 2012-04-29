mongoose = require 'mongoose'

class Todos
  constructor: (db) ->
    mongoose.connect db

    @db = new mongoose.Schema {
        title: String
      , description: String
      , completed: Boolean
      , default: 0
    }

    mongoose.model 'Todos', @db
    @db = mongoose.model 'Todos'

  list: (callback) ->
    @db.find({}, (err, todos) ->
      todos.sort (a,b) ->
        if a.completed
          return 1
        else
          return -1
      callback(err, todos)
    )

  add: (title, description, completed, callback) ->
    if !completed
      completed = false
    new @db({title: title, description: description, completed: completed}).save (err) ->
      callback err

  update: (id, title, description, callback) ->
    @db.update {_id: id}, { $set: {title:title, description:description}}, (err) ->
      callback err

  completeChange: (id, completed, callback) ->
    @db.update {_id: id}, { $set: {completed: completed}}, (err) ->
      callback err

  remove: (id, callback) ->
    @db.remove {_id: id}, (err) ->
      callback err

  findOne: (obj, callback) ->
    @db.findOne obj, callback

module.exports.connect = (db) ->
  new Todos(db)
