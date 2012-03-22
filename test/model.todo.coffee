Todos = require "../model/todo"
should = require "should"

describe "Todos", ->
  describe "todo", ->

    beforeEach (done) ->
      Todos.remove {}, ()->
        new Todos({title: 'hogehogetitle', description: 'fugafuga', completed: true}).save (err) ->
          done(err)

    afterEach (done) ->
      Todos.remove {title: 'hogehogetitle'}, (err) ->
        done(err)

    it "todosが配列であること", (done) ->
      callback = (err, todos) ->
        todos.should.be.an.instanceof Array
        done()
      Todos.list callback

    it "todosに1個だけ要素があること", (done) ->
      callback = (err, todos) ->
        todos.should.have.length 1
        done()
      Todos.list callback

  describe "add_todo", ->
    it "completedがfalseになっていること", (done) ->
      callback = (err) ->
        Todos.findOne {title: 'hoge'}, (err, todo) ->
          todo.completed.should.be.false
          done err
      Todos.add_todo 'hoge', 'fuga', undefined, callback
