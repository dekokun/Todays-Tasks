(function() {
  var app, express, index, messages, task, todo;

  express = require("express");

  index = require("./routes/index");

  todo = require("./routes/todo");

  task = require("./routes/task");

  messages = require("express-messages");

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
    app.use(express.static(__dirname + "/public"));
    return app.dynamicHelpers({
      messages: messages
    });
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

  app.get("/", index.index);

  app.get("/todo", todo.todo);

  app.post("/todo", todo.add);

  app.put("/todo/:id/nice", todo.nice);

  app.put("/todo/:id", todo.completeChange);

  app.del("/todo/:id", todo.del);

  app.get("/task", task.tasks);

  app.post("/task", task.add);

  app.del("/task/:id", task.del);

  app.listen(process.env.NODE_PORT || 443);

  console.log("Express server listening on port %d in %s mode", app.address().port, app.settings.env);

}).call(this);
