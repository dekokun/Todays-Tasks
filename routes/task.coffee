Tasks = require("../model/task")

exports.tasks = (req, res) ->
  Tasks.find({}, (err, tasks) ->
    res.render('task', {
      tasks: tasks,
      title: 'Tasks'
    })
  )

exports.add = (req, res) ->
  new Tasks({title: req.body.title, description: req.body.description, url: req.body.url}).save (err) ->
    res.redirect('/task')

exports.del = (req, res) ->
  req.flash('alert-info', '削除しました')
  console.log req.params.id
  Tasks.remove {_id: req.params.id}, (err) ->
    res.redirect('/task')


