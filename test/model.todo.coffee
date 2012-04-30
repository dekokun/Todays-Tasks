db = 'mongodb://localhost/test'

Todos = if process.env.TEST_COV then require("../model-cov/todo").connect(db) else require("../model/todo").connect(db)

mongoose = require 'mongoose'

should = require "should"

mongoose.connect db
db = new mongoose.Schema {
    title: String
  , description: String
  , completed: Boolean
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
          new db({title: 'hogehogetitle', description: 'fugafuga', completed: true, isTop: true}).save (err) ->
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
          new db({title: 'false', description: 'fugafuga', completed: false, isTop:true}).save (err) ->
            new db({title: 'hogehogetitle', description: 'fugafuga', completed: true, isTop: true}).save (err) ->
              new db({title: 'nice', description: 'fugafuga', completed: false, isTop: true}).save (err) ->
                done(err)

      it "todosに3個要素があること", (done) ->
        callback = (err, todos) ->
          todos.should.have.length 3
          done()
        Todos.list callback

      it "一番最後は完了してるものであること", (done) ->
        callback = (err, todos) ->
          todos[2].completed.should.be.equal true
          done()
        Todos.list callback

      it "完了していないものが2番にくること", (done) ->
        callback = (err, todos) ->
          todos[1].completed.should.be.equal false
          done()
        Todos.list callback

  describe "add", ->
    it "completedがfalseになっていること", (done) ->
      callback = (err) ->
        db.findOne {title: 'hoge'}, (err, todo) ->
          todo.completed.should.be.false
          done err
      Todos.add 'hoge', 'fuga', undefined, undefined, callback

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

  describe "update", ->
    id = {}
    beforeEach (done) ->
      beforeTitle = 'title1'
      new db({title: beforeTitle, description: 'hogehogedescription', completed: true}).save (err) ->
        done err if err
        db.findOne {title: beforeTitle}, (err, todo) ->
          id = todo._id
          done err
    it "titleが変わっている", (done) ->
      afterTitle = "title2"
      callback = (err) ->
        db.findOne {_id: id}, (err, todo) ->
          todo.title.should.be.equal afterTitle
          done err
      Todos.update id, afterTitle, 'hoge', callback
    it "descriptionが変わっている", (done) ->
      afterDescription = "description2"
      callback = (err) ->
        db.findOne {_id: id}, (err, todo) ->
          todo.description.should.be.equal afterDescription
          done err
      Todos.update id, 'hoge', afterDescription, callback

  describe "findOne", ->
    id = {}
    searchTitle = 'hogehoge'
    beforeEach (done) ->
      new db({title: searchTitle}).save (err) ->
        done err if err
        new db({title: 'hogehogeTitle'}).save (err) ->
          db.findOne {title: searchTitle}, (err, todo) ->
            id = todo._id
            done err
    it "title検索でdb.findOneと同じものが取得できている", (done) ->
      callback = (err) ->
        db.findOne {_id: id}, (err, todo) ->
          todo._id.should.be.eql id
          done err
      Todos.findOne {title:searchTitle}, callback

    it "id検索でdb.findOneと同じものが取得できている", (done) ->
      callback = (err) ->
        db.findOne {_id: id}, (err, todo) ->
          todo.title.should.be.eql searchTitle
          done err
      Todos.findOne {_id:id}, callback
