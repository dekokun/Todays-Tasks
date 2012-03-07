(function() {
  var Tasks, Todos, app, express, mongoose, routes;

  express = require("express");

  routes = require("./routes");

  app = module.exports = express.createServer();

  app.configure(function() {
    app.set("views", __dirname + "/views");
    app.set("view engine", "jade");
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(express.cookieParser());
    app.use(express.session({
      secret: "your secret here"
    }));
    app.use(app.router);
    return app.use(express.static(__dirname + "/public"));
  });

  app.configure("development", function() {
    return app.use(express.errorHandler({
      dumpExceptions: true,
      showStack: true
    }));
  });

  app.configure("production", function() {
    return app.use(express.errorHandler());
  });

  mongoose = require('mongoose');

  mongoose.connect('mongodb://localhost/everydaystasks');

  Tasks = new mongoose.Schema({
    title: String,
    description: String,
    url: String
  });

  mongoose.model('Tasks', Tasks);

  Tasks = mongoose.model('Tasks');

  Todos = new mongoose.Schema({
    title: String,
    description: String,
    completed: Boolean
  });

  mongoose.model('Todos', Todos);

  Todos = mongoose.model('Todos');

  app.get("/", routes.index(Tasks));

  app.get("/todo", routes.todo(Todos));

  app.post("/todo", routes.add_todo(Todos));

  app.put("/todo/:id", routes.change_todo(Todos));

  app.del("/todo/:id", routes.del_todo(Todos));

  app.get("/task", routes.tasks(Tasks));

  app.post("/task", routes.add_task(Tasks));

  app.del("/task/:id", routes.del_task(Tasks));

  app.listen(process.env.NODE_PORT || 443);

  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);

}).call(this);
