Tasks = require("../model/task")

exports.index = (req, res) ->
  Tasks.find({}, (err, tasks) ->
    res.render('check', {
      tasks: tasks,
      title: 'Todays Tasks'
    })
  )

