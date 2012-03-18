Tasks = require("../model/task")

exports.index = (req, res) ->
  collection.find({}, (err, tasks) ->
    res.render('check', {
      tasks: tasks,
      title: 'Todays Tasks'
    })
  )

