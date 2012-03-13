express = require("express")
index = require("./routes/index")
todo = require("./routes/todo")
task = require("./routes/task")


app = module.exports = express.createServer()
app.configure ->
  app.set "views", __dirname + "/views"
  app.set "view engine", "jade"
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use express.cookieParser()
  app.use express.session(secret: "your secret here")
  app.use app.router
  app.use express.static(__dirname + "/public")

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

# model
Todos = require("./model/todo")
Tasks = require("./model/task")

app.configure "production", ->
  app.use express.errorHandler()

app.get "/", index.index(Tasks)

app.get "/todo", todo.todo(Todos)
app.post "/todo", todo.add_todo(Todos)
app.put "/todo/:id/nice", todo.nice(Todos)
app.put "/todo/:id", todo.change_todo(Todos)
app.del "/todo/:id", todo.del_todo(Todos)

app.get "/task", task.tasks(Tasks)
app.post "/task", task.add_task(Tasks)
app.del "/task/:id", task.del_task(Tasks)

app.listen process.env.NODE_PORT || 443
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
