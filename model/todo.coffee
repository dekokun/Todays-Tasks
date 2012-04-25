mongoose = require 'mongoose'

class Todos
  constructor: (db) ->
    mongoose.connect db

    @db = new mongoose.Schema {
        title: String
      , description: String
      , completed: Boolean
      , nice: Number
      , default: 0
    }

    mongoose.model 'Todos', @db
    @db = mongoose.model 'Todos'

  list: (callback) ->
    @db.find({}, (err, todos) ->
      todos.sort (a,b) ->
        a.nice = a.nice ? 0
        b.nice = b.nice ? 0
        if a.completed == b.completed
          return b.nice - a.nice
        else if a.completed
          return 1
        else
          return -1
      callback(err, todos)
    )

  add: (title, description, completed, callback) ->
    if !completed
      completed = false
    new @db({title: title, description: description, completed: completed, nice:0}).save (err) ->
      callback err

  completeChange: (id, completed, callback) ->
    @db.update {_id: id}, { $set: {completed: completed}}, (err) ->
      callback err

  remove: (id, callback) ->
    @db.remove {_id: id}, (err) ->
      callback err

module.exports.connect = (db) ->
  new Todos(db)
