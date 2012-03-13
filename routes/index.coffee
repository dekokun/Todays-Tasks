exports.index = (collection) ->
  (req, res) ->
    collection.find({}, (err, tasks) ->
      res.render('check', {
        tasks: tasks,
        title: 'Todays Tasks'
      })
    )

