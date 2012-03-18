routes = require "../routes/todo"
should = require "should"
Todos = require("../model/todo")

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
      new Todos({title: 'hogehogetitle', description: 'fugafuga', completed: true}).save (err) ->
        done(err)

    afterEach (done) ->
      Todos.remove {title: 'hogehogetitle'}, (err) ->
        done(err)

    it "todosが配列であること", (done) ->
      res.render = (view, vars) ->
        vars.todos.should.be.an.instanceof Array
        done()
      routes.todo(req, res)
