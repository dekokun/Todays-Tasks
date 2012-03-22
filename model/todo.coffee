mongoose = require './db'

Todos = new mongoose.Schema {title: String, description: String, completed: Boolean, nice: Number, default: 0}
mongoose.model 'Todos', Todos
Todos = mongoose.model 'Todos'

Todos.list = (callback) ->
  this.find({}, (err, todos) ->
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

Todos.add_todo = (title, description, completed, callback) ->
  if !completed
    completed = false
  new Todos({title: title, description: description, completed: completed}).save (err) ->
    callback err

module.exports = Todos
