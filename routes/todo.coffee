exports.todo = (collection) ->
  (req, res) ->
    collection.find({}, (err, todos) ->
      todos.sort (a,b) ->
        a.nice = a.nice ? 0
        b.nice = b.nice ? 0
        if a.completed == b.completed
          return b.nice - a.nice
        else if a.completed
          return 1
        else
          return -1
      res.render('todo', {
        todos: todos,
        title: 'TODO'
      })
    )

exports.add = (collection) ->
  (req, res) ->
    if !(completed = req.body.completed)
      completed = false
    new collection({title: req.body.title, description: req.body.description, completed: completed}).save (err) ->
      res.redirect('/todo')

exports.del = (collection) ->
  (req, res) ->
    req.flash('alert-info', '削除しました')
    collection.remove {_id: req.params.id}, (err) ->
      res.redirect('/todo')

exports.change = (collection) ->
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

