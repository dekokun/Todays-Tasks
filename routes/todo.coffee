Todos = require("../model/todo")

exports.todo = (req, res) ->
  Todos.list (err, todos) ->
    res.render('todo', {
      todos: todos,
      title: 'TODO'
    })

exports.add = (req, res) ->
  if !(completed = req.body.completed)
    completed = false
  new Todos({title: req.body.title, description: req.body.description, completed: completed}).save (err) ->
    res.redirect('/todo')

exports.del = (req, res) ->
  req.flash('alert-info', '削除しました')
  Todos.remove {_id: req.params.id}, (err) ->
    res.redirect('/todo')

exports.change = (req, res) ->
  if (req.body.completed == "false" || !req.body.completed)
    completed = false
  else
    completed = true
  Todos.update {_id: req.params.id}, { $set: {completed: completed}}, (err) ->
    res.redirect('/todo')

exports.nice = (req, res) ->
  Todos.update {_id: req.params.id}, { $inc: {nice: 1}}, (err) ->
    res.redirect('/todo')

