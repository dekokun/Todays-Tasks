Todos = if process.env.TEST_COV then require "../model-cov/todo" else require "../model/todo"

should = require "should"

describe "Todos", ->
  afterEach (done) ->
    Todos.remove {}, (err) ->
      done(err)
    beforeEach (done) ->
      Todos.remove {}, (err)->
        done(err)

  describe "todo_list", ->

    describe "todoがひとつだけ", ->
      beforeEach (done) ->
        Todos.remove {}, ()->
          new Todos({title: 'hogehogetitle', description: 'fugafuga', completed: true}).save (err) ->
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
        Todos.remove {}, ()->
          new Todos({title: 'false', description: 'fugafuga', completed: false}).save (err) ->
            new Todos({title: 'hogehogetitle', description: 'fugafuga', completed: true}).save (err) ->
              new Todos({title: 'nice', description: 'fugafuga', completed: false, nice:2}).save (err) ->
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

  describe "add_todo", ->
    it "completedがfalseになっていること", (done) ->
      callback = (err) ->
        Todos.findOne {title: 'hoge'}, (err, todo) ->
          todo.completed.should.be.false
          done err
      Todos.add_todo 'hoge', 'fuga', undefined, callback

    # nice.todoがNumberをコンストラクタとするオブジェクトのため、
    # 比較ができない
    # 苦肉の策で存在確認(null, undifined, falseではないこと)とtodo.nice-0が0であることを以てテスト完了とする
    it "niceが存在すること", (done) ->
      callback = (err) ->
        Todos.findOne {title: 'hoge'}, (err, todo) ->
          todo.nice.should.be.exist
          done err
      Todos.add_todo 'hoge', 'fuga', undefined, callback
    it "niceの値が0であること", (done) ->
      callback = (err) ->
        Todos.findOne {title: 'hoge'}, (err, todo) ->
          (todo.nice - 0).should.be.equal 0
          done err
      Todos.add_todo 'hoge', 'fuga', undefined, callback
