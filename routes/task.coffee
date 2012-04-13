Tasks = require("../model/task").connect 'mongodb://localhost/everydaystasks'

exports.tasks = (req, res) ->
  Tasks.all_task req, res, (err, tasks)->
    res.render('task', {
      tasks: tasks,
      title: 'Tasks'
    })

exports.add = (req, res) ->
  Tasks.add_task req, res, (err) ->
    res.redirect('/task')

exports.del = (req, res) ->
  req.flash('alert-info', '削除しました')
  Tasks.del_task req, res, (err) ->
    res.redirect('/task')


