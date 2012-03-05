exports.index = (req, res) ->
  res.render "index",
    title: "Todays tasks"

exports.tasks = (collection) ->
  (req, res) ->
    collection.find({}, (err, tasks) ->
      res.render('tasks', {
        tasks: tasks,
        title: 'Tasks'
      })
    )

exports.add_task = (collection) ->
  (req, res) ->
    console.dir req.body
    new collection({title: req.body.title, description: req.body.description, url: req.body.url}).save (err) ->
      res.redirect('/tasks')
