Todos = require("../model/todo").connect 'mongodb://localhost/everydaystasks'

exports.todo = (req, res) ->
  Todos.list (err, todos) ->
    res.render('todo', {
      todos: todos,
      title: 'TODO'
    })

exports.add = (req, res) ->
  Todos.add req.body.title, req.body.description, req.body.completed, (err) ->
    res.redirect('/todo')

exports.del = (req, res) ->
  req.flash('alert-info', '削除しました')
  Todos.remove req.params.id, (err) ->
    res.redirect('/todo')

exports.completed_toggle = (req, res) ->
  if (req.body.completed == "false" || !req.body.completed)
    completed = false
  else
    completed = true
  Todos.completed_change req.params.id, completed, (err) ->
    res.redirect('/todo')

exports.nice = (req, res) ->
  Todos.update {_id: req.params.id}, { $inc: {nice: 1}}, (err) ->
    res.redirect('/todo')

