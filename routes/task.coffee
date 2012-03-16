exports.tasks = (collection) ->
  (req, res) ->
    collection.find({}, (err, tasks) ->
      res.render('task', {
        tasks: tasks,
        title: 'Tasks'
      })
    )

exports.add = (collection) ->
  (req, res) ->
    new collection({title: req.body.title, description: req.body.description, url: req.body.url}).save (err) ->
      res.redirect('/task')

exports.del = (collection) ->
  (req, res) ->
    req.flash('alert-info', '削除しました')
    console.log req.params.id
    collection.remove {_id: req.params.id}, (err) ->
      res.redirect('/task')


