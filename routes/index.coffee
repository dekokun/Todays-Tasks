Tasks = require("../model/task").connect 'hoge'

exports.index = (req, res) ->
  Tasks.all_task req, res, (err, tasks)->
    res.render('check', {
      tasks: tasks,
      title: 'Todays Tasks'
    })

