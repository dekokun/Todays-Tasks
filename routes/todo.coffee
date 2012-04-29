Todos = require("../model/todo").connect 'mongodb://localhost/everydaystasks'
markdown = require("markdown").markdown

exports.todo = (req, res) ->
  Todos.list (err, todos) ->
    todos = for todo in todos
      todo["markdown"] = markdown.toHTML(todo.description)
      todo
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

exports.completeChange = (req, res) ->
  if (req.body.completed == "false" || !req.body.completed)
    completed = false
  else
    completed = true
  Todos.completeChange req.params.id, completed, (err) ->
    res.redirect('/todo')

exports.edit = (req, res) ->
  Todos.findOne {_id: req.params.id}, (err, todo) ->
    res.render('todoEdit', {
      todo: todo,
      title: 'edit'
    })

exports.update = (req, res) ->
  Todos.update req.params.id, req.body.title, req.body.description, (err) ->
    res.redirect('/todo')
