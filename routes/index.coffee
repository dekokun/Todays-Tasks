exports.index = (collection) ->
  (req, res) ->
    collection.find({}, (err, tasks) ->
      res.render('check', {
        tasks: tasks,
        title: 'Todays Tasks'
      })
    )

exports.tasks = (collection) ->
  (req, res) ->
    collection.find({}, (err, tasks) ->
      res.render('task', {
        tasks: tasks,
        title: 'Tasks'
      })
    )

exports.add_task = (collection) ->
  (req, res) ->
    new collection({title: req.body.title, description: req.body.description, url: req.body.url}).save (err) ->
      res.redirect('/task')

exports.del_task = (collection) ->
  (req, res) ->
    console.log req.params.id
    collection.remove {_id: req.params.id}, (err) ->
      res.redirect('/task')

exports.todo = (collection) ->
  (req, res) ->
    collection.find({}, (err, todos) ->
      res.render('todo', {
        todos: todos,
        title: 'TODO'
      })
    )

exports.add_todo = (collection) ->
  (req, res) ->
    if !(deleted = req.body.deleted)
      deleted = false
    new collection({title: req.body.title, description: req.body.description, deleted: deleted}).save (err) ->
      res.redirect('/todo')

exports.del_todo = (collection) ->
  (req, res) ->
    console.log req.params.id
    collection.remove {_id: req.params.id}, (err) ->
      res.redirect('/todo')
