express = require("express")
routes = require("./routes")
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

app.configure "production", ->
  app.use express.errorHandler()

mongoose = require 'mongoose'
mongoose.connect 'mongodb://localhost/everydaystasks'
Tasks = new mongoose.Schema {title: String, description: String, url: String}
mongoose.model 'Tasks', Tasks
Tasks = mongoose.model 'Tasks'


app.get "/", routes.index
app.get "/tasks", routes.tasks(Tasks)
app.post "/", routes.add_task(Tasks)

app.listen 443
console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env
