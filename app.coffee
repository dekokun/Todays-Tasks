express = require("express")
index = require("./routes/index")
todo = require("./routes/todo")
task = require("./routes/task")
messages = require("express-messages")


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
  app.dynamicHelpers({ messages: messages });

app.configure "development", ->
  app.use express.errorHandler(
    dumpExceptions: true
    showStack: true
  )

app.configure "production", ->
  app.use express.errorHandler()

app.get "/", index.index

app.get "/todo", todo.todo
app.post "/todo", todo.add
app.put "/todo/:id/nice", todo.nice
app.put "/todo/:id", todo.completed_toggle
app.del "/todo/:id", todo.del

app.get "/task", task.tasks
app.post "/task", task.add
app.del "/task/:id", task.del

app.listen process.env.NODE_PORT || 443
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
