db = 'mongodb://localhost/test'

mongoose = require 'mongoose'
routes = require "../routes/todo"
should = require "should"

mongoose.connect db
db = new mongoose.Schema {
    title: String
  , description: String
  , completed: Boolean
  , nice: Number
  , default: 0
}

mongoose.model 'Todos', db
db = mongoose.model 'Todos'

describe "routes", ->
  req =
    params: {}
    body: {}
  res =
    redirect: (route) ->
      #do nothing
    render: (view, vars)->
      #do nothing

  describe "todo", ->
    beforeEach (done) ->
      new db({title: 'hogehogetitle', description: 'fugafuga', completed: true}).save (err) ->
        done(err)

    afterEach (done) ->
      db.remove {title: 'hogehogetitle'}, (err) ->
        done(err)

    it "todosが配列であること", (done) ->
      res.render = (view, vars) ->
        vars.todos.should.be.an.instanceof Array
        done()
      routes.todo(req, res)
