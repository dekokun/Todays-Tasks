exports.todo = (collection) ->
  (req, res) ->
    collection.find({}, (err, todos) ->
      todos.sort (a,b) ->
        return b.nice - a.nice
      res.render('todo', {
        todos: todos,
        title: 'TODO'
      })
    )

exports.add_todo = (collection) ->
  (req, res) ->
    if !(completed = req.body.completed)
      completed = false
    new collection({title: req.body.title, description: req.body.description, completed: completed}).save (err) ->
      res.redirect('/todo')

exports.del_todo = (collection) ->
  (req, res) ->
    console.log req.params.id
    collection.remove {_id: req.params.id}, (err) ->
      res.redirect('/todo')

exports.change_todo = (collection) ->
  (req, res) ->
    if (req.body.completed == "false" || !req.body.completed)
      completed = false
    else
      completed = true
    collection.update {_id: req.params.id}, { $set: {completed: completed}}, (err) ->
      res.redirect('/todo')

exports.nice = (collection) ->
  (req, res) ->
    collection.update {_id: req.params.id}, { $inc: {nice: 1}}, (err) ->
      res.redirect('/todo')
