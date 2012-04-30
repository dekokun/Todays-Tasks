mongoose = require 'mongoose'
async = require 'async'

class Todos
  constructor: (db) ->
    mongoose.connect db

    @db = new mongoose.Schema {
        title: String
      , description: String
      , completed: Boolean
      , parent: String
      , isTop: { type:Boolean, default: false }
    }

    mongoose.model 'Todos', @db
    @db = mongoose.model 'Todos'

  list: (callback) ->
    todoSort = (todos) ->
      todos.sort (a,b) ->
        if a.completed
          return 1
        else
          return -1

    db = @db
    db.find({isTop: true}, (err, parents) ->
      func = []
      myfunc = (todo) ->
        (callback) ->
          db.find({parent: todo._id}, (err, children) ->
            todoSort(children)
            todo.todos = children
            callback(err, todo)
          )
      for parent in parents
        func.push (myfunc parent)
      async.parallel(func, (err, results)->
        todoSort(results)
        callback(err, results)
      )
    )

  all: (callback) ->
    @db.find {}, (err, todos) ->
      callback err, todos

  add: (title, description, completed, parent, callback) ->
    isTop = true
    if parent?
      isTop = false
    if !completed
      completed = false
    new @db({title: title, description: description, completed: completed, isTop: isTop, parent: parent}).save (err) ->
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
