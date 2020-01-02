const express = require("express");
const hbs = require("express-handlebars");
const app = express();
const bodyParser = require("body-parser");
const admin = require("firebase-admin");

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

const helpers = require("./utils/helpers");

// firebase db setup
let serviceAccount = require("./ServiceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

let db = admin.firestore();

// insert todo into firebase db
const insertTodo = obj => {
  return db
    .collection("todos")
    .doc()
    .set({
      task: obj.task,
      note: obj.note,
      category: obj.category,
      due: new Date(obj.due),
      created: new Date()
    });
};

const insertCategory = obj => {
  return db
    .collection("categories")
    .doc()
    .set(obj);
};

// delete todo into firebase db
const deleteTodo = id => {
  return db
    .collection("todos")
    .doc(id)
    .delete();
};

const deleteCategory = id => {
  return db
    .collection("categories")
    .doc(id)
    .delete();
};

const deleteTodosByCategory = async id => {
  const toBeDeleted = await db
    .collection("todos")
    .where("category", "==", id)
    .get();
  toBeDeleted.forEach(doc => doc.ref.delete());
};

const getTodos = async () => {
  // get todos from the database
  try {
    const snapshot = await db.collection("todos").get();
    const result = [];
    snapshot.forEach(doc => {
      result.push({
        ...doc.data(),
        ...{
          due: doc
            .data()
            .due.toDate()
            .toUTCString(),
          created: doc
            .data()
            .created.toDate()
            .toUTCString(),
          id: doc.id
        }
      });
    });
    return result;
  } catch (error) {
    console.log(error);
  }
};

const getCategories = async () => {
  // get categories from the database
  try {
    const snapshot = await db.collection("categories").get();
    const result = [];
    snapshot.forEach(doc => {
      result.push({ ...doc.data(), id: doc.id });
    });
    return result;
  } catch (error) {
    console.log(error);
  }
};

app.get("/", async (req, res, next) => {
  // retrieve todos from the database
  const todos = await getTodos();
  const categories = await getCategories();
  res.render("home", {
    active: "All Tasks",
    todos, // pass it to the template
    empty: todos.lenght === 0,
    categories
  });
});

app.get("/categories/:id", async (req, res) => {
  const todos = await getTodos();
  const categories = await getCategories();
  const todosByCategory = todos.filter(item => item.category === req.params.id);
  const categoryName = helpers.getCategoryName(categories, req.params.id);
  res.render("home", {
    active: helpers.capitalize(categoryName),
    todos: todosByCategory,
    empty: todosByCategory.lenght === 0,
    categories
  });
});

app.get("/today", async (req, res) => {
  const todos = await getTodos();
  const today = todos.filter(
    todo => todo.due.slice(5, 16) === new Date().toUTCString().slice(5, 16)
  );
  const categories = await getCategories();
  res.render("home", {
    active: "Today",
    todos: today,
    empty: today.lenght === 0,
    categories
  });
});

app.post("/add", async (req, res) => {
  // process an add todo request
  try {
    await insertTodo(req.body);
  } catch (error) {
    res.status(503).send(error.message);
  }
  res.redirect("/"); // redirect to the home page
});

app.post("/addcategory", async (req, res) => {
  try {
    await insertCategory(req.body);
  } catch (error) {
    res.status(503).send(error.message);
  }
  res.redirect("/");
});

app.post("/delete", async (req, res) => {
  try {
    await deleteTodo(req.body.id);
  } catch (error) {
    res.status(503).send(error.message);
  }
  res.redirect("/");
});

app.post("/deletecategory", async (req, res) => {
  try {
    await deleteTodosByCategory(req.body.id);
    await deleteCategory(req.body.id);
  } catch (error) {
    res.status(503).send(error.message);
  }
  res.redirect("/");
});

// express view engine setup
app.engine("hbs", hbs({ defaultLayout: "main", extname: ".hbs" }));

app.set("view engine", "hbs");

app.listen(3000, () => {
  console.log("Listening on http://localhost:3000/");
});
