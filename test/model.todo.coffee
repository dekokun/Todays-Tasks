db = 'mongodb://localhost/test'

Todos = if process.env.TEST_COV then require("../model-cov/todo").connect(db) else require("../model/todo").connect(db)

mongoose = require 'mongoose'

should = require "should"

mongoose.connect db
db = new mongoose.Schema {
    title: String
  , description: String
  , completed: Boolean
  , nice: Number
  , default: 0
}

mongoose.model 'Todos', @db
db = mongoose.model 'Todos'

describe "Todos", ->
  afterEach (done) ->
    db.remove {}, (err) ->
      done(err)
  beforeEach (done) ->
    db.remove {}, (err)->
      done(err)

  describe "todo_list", ->

    describe "todoがひとつだけ", ->
      beforeEach (done) ->
        db.remove {}, ()->
          new db({title: 'hogehogetitle', description: 'fugafuga', completed: true}).save (err) ->
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

    describe "todoが3つ", ->
      beforeEach (done) ->
        db.remove {}, ()->
          new db({title: 'false', description: 'fugafuga', completed: false}).save (err) ->
            new db({title: 'hogehogetitle', description: 'fugafuga', completed: true}).save (err) ->
              new db({title: 'nice', description: 'fugafuga', completed: false, nice:2}).save (err) ->
                done(err)

      it "todosに3個要素があること", (done) ->
        callback = (err, todos) ->
          todos.should.have.length 3
          done()
        Todos.list callback

      it "niceが高いものが1番にくること", (done) ->
        callback = (err, todos) ->
          todos[0].title.should.be.equal 'nice'
          done()
        Todos.list callback

      it "完了していないものが2番にくること", (done) ->
        callback = (err, todos) ->
          todos[1].title.should.be.equal 'false'
          done()
        Todos.list callback

  describe "add", ->
    it "completedがfalseになっていること", (done) ->
      callback = (err) ->
        db.findOne {title: 'hoge'}, (err, todo) ->
          todo.completed.should.be.false
          done err
      Todos.add 'hoge', 'fuga', undefined, callback

    # nice.todoがNumberをコンストラクタとするオブジェクトのため、
    # 比較ができない
    # 苦肉の策で存在確認(null, undifined, falseではないこと)とtodo.nice-0が0であることを以てテスト完了とする
    it "niceが存在すること", (done) ->
      callback = (err) ->
        db.findOne {title: 'hoge'}, (err, todo) ->
          todo.nice.should.be.exist
          done err
      Todos.add 'hoge', 'fuga', undefined, callback
    it "niceの値が0であること", (done) ->
      callback = (err) ->
        db.findOne {title: 'hoge'}, (err, todo) ->
          (todo.nice - 0).should.be.equal 0
          done err
      Todos.add 'hoge', 'fuga', undefined, callback

  describe "remove", ->
    id = {}
    beforeEach (done) ->
      new db({title: 'hogehogetitle', description: 'fugafuga', completed: true}).save (err) ->
        done err if err
        db.findOne {title: 'hogehogetitle'}, (err, todo) ->
          id = todo._id
          done err
    it "削除したものは存在しないこと", (done) ->
      callback = (err) ->
        db.findOne {title: 'hogehogetitle'}, (err, todo) ->
          should.not.exist todo
          done err
      Todos.remove id, callback

  describe "completeChange", ->
    describe "最初がtrueの時", ->
      id = {}
      beforeEach (done) ->
        new db({title: 'hogehogetitle', description: 'fugafuga', completed: true}).save (err) ->
          done err if err
          db.findOne {title: 'hogehogetitle'}, (err, todo) ->
            id = todo._id
            done err
      it "falseをセットすればfalseになる", (done) ->
        callback = (err) ->
          db.findOne {title: 'hogehogetitle'}, (err, todo) ->
            todo.completed.should.be.false
            done err
        Todos.completeChange id, false, callback
      it "trueをセットすればtrueになる", (done) ->
        callback = (err) ->
          db.findOne {title: 'hogehogetitle'}, (err, todo) ->
            todo.completed.should.be.true
            done err
        Todos.completeChange id, true, callback
    describe "最初がfalseの時", ->
      id = {}
      beforeEach (done) ->
        new db({title: 'hogehogetitle', description: 'fugafuga', completed: false}).save (err) ->
          done err if err
          db.findOne {title: 'hogehogetitle'}, (err, todo) ->
            id = todo._id
            done err
      it "falseをセットすればfalseになる", (done) ->
        callback = (err) ->
          db.findOne {title: 'hogehogetitle'}, (err, todo) ->
            todo.completed.should.be.false
            done err
        Todos.completeChange id, false, callback
      it "trueをセットすればtrueになる", (done) ->
        callback = (err) ->
          db.findOne {title: 'hogehogetitle'}, (err, todo) ->
            todo.completed.should.be.true
            done err
        Todos.completeChange id, true, callback
