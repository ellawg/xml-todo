<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns="http://www.w3.org/1999/xhtml">

  <xsl:template match="data">
    <html lang="en">
      <head>
        <meta charset="UTF-8" />
        <title>Task tracker</title>
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" integrity="sha384-Gn5384xqQ1aoWXA+058RXPxPg6fy4IWvTNh0E263XmFcJlSAwiGgFAW/dAiS6JXm" crossorigin="anonymous"/>
        <link href="/styles.css" rel="stylesheet" />
      </head>

      <body>
        <!-- header -->
        <header class="text-center">
          <h2>Task tracker</h2>
          <h3> Keep track of all your tasks! </h3>
        </header>
        <div class="container">
          <div class="row justify-content-center">
            <!-- navbar -->
            <div class="col-4">
              <ul class="nav nav-pills flex-column">
                <li class="nav-item">
                  <button class="btn btn-link">
                    <a href="/">All Tasks</a>
                  </button>
                </li>
                <li class="nav-item">
                  <button class="btn btn-link">
                    <a href="/today">Today</a>
                  </button>
                </li>
                <li class="nav-item">
                  <button class="btn btn-link" type="button" data-toggle="collapse" data-target="#collapseCategories" aria-expanded="false" aria-controls="collapseCategories">Categories</button>
                  <div class="collapse" id="collapseCategories">
                    <div class="card card-body">
                      <!-- all categories -->
                      <xsl:for-each select="categories/category">
                        <div class="row category-row">
                          <div class="col-9 d-flex align-items-center p-0">
                            <a class="dropdown-item" href="/categories/{@id}">
                              <xsl:value-of select="."/>
                            </a>
                          </div>
                          <div class="col-3 d-flex flex-row justify-content-end align-items-center">
                            <form action="/deletecategory" method="post">
                              <input type="hidden" value="{@id}" name="id" />
                              <button type="submit" class="btn btn-primary">X</button>
                            </form>
                          </div>
                        </div>
                      </xsl:for-each>
                    </div>
                  </div>
                </li>
                <li class="nav-item">
                  <button class="btn btn-link" type="button" data-toggle="collapse" data-target="#collapseCatForm" aria-expanded="false" aria-controls="collapseCatForm">Add category</button>
                  <div class="collapse" id="collapseCatForm">
                    <div class="card card-body">
                      <form action="/addcategory" method="post">
                        <div class="form-group">
                          <input required="required" type="text" class="form-control" name="category" placeholder="Enter category name" />
                        </div>
                        <button class="form-control" type="submit">Add category</button>
                      </form>
                    </div>
                  </div>
                </li>
              </ul>
            </div>

            <!-- content -->
            <div class="col-6">
              <div class="accordion tasks" id="taskAccordion">
                <!-- all todos -->
                <xsl:for-each select="todos/todo">
                  <div class="card">
                    <div class="card-header d-flex flex-row" id="heading{@id}">
                      <div class="col-9 d-flex align-items-center" data-toggle="collapse" data-target="#collapse{@id}" aria-expanded="false" aria-controls="collapse{@id}">
                        <p>
                          <xsl:value-of select="task"/>
                        </p>
                      </div>
                      <div class="col-3 d-flex flex-row justify-content-end align-items-center">
                        <form action="/delete" method="post">
                          <input type="hidden" value="{@id}" name="id" />
                          <button type="submit" class="btn btn-primary task-btn">X</button>
                        </form>
                        <form action="/complete" method="post">
                          <input type="hidden" value="{@id}" name="id" />
                          <button type="submit" class="btn btn-success task-btn">✓</button>
                        </form>
                      </div>
                    </div>

                    <div class="collapse" id="collapse{@id}" aria-labelledby="heading{@id}" data-parent="#taskAccordion">
                      <div class="card-body">
                        <p>
                          <xsl:value-of select="note"/>
                        </p>
                        <p class="text-grey">
                          <i class="far fa-calendar" id="calendar"></i>
                          <xsl:value-of select="due"/>
                        </p>
                        <p class="text-grey text-small">Created <xsl:value-of select="created"/>
                        </p>
                      </div>
                    </div>
                  </div>
                </xsl:for-each>
                <!-- all completed todos -->
                <xsl:for-each select="completed-todos/todo">
                  <div class="card">
                    <div class="card-header d-flex flex-row" id="heading{@id}">
                      <div class="col-9 d-flex align-items-center" data-toggle="collapse" data-target="#collapse{@id}" aria-expanded="false" aria-controls="collapse{@id}">
                        <p>
                          <xsl:value-of select="task"/>
                        </p>
                      </div>
                      <div class="col-3 d-flex flex-row justify-content-end align-items-center">
                        <form action="/delete" method="post">
                          <input type="hidden" value="{@id}" name="id" />
                          <button type="submit" class="btn btn-primary task-btn">X</button>
                        </form>
                        <form action="/uncomplete" method="post">
                          <input type="hidden" value="{@id}" name="id" />
                          <button type="submit" class="btn btn-danger task-btn">↺</button>
                        </form>
                      </div>
                    </div>

                    <div class="collapse" id="collapse{@id}" aria-labelledby="heading{@id}" data-parent="#taskAccordion">
                      <div class="card-body">
                        <p>
                          <xsl:value-of select="note"/>
                        </p>
                        <p class="text-grey">
                          <i class="far fa-calendar" id="calendar"></i>
                          <xsl:value-of select="due"/>
                        </p>
                        <p class="text-grey text-small">Created <xsl:value-of select="created"/>
                        </p>
                      </div>
                    </div>
                  </div>
                </xsl:for-each>
              </div>

              <!-- add task button -->
              <button class="btn btn-primary" type="button" data-toggle="collapse" data-target="#collapseTaskForm" aria-expanded="false" aria-controls="collapseTaskForm">
                Add task
              </button>
              <div class="collapse" id="collapseTaskForm">
                <div class="card card-body">
                  <form action="/add" method="post">
                    <div class="form-group">
                      <input required="required" type="text" class="form-control" name="task" placeholder="add new task" />
                    </div>
                    <div class="form-group">
                      <input type="text" name="note" class="form-control" placeholder="enter task note"/>
                    </div>
                    <div class="form-group">
                      <select name="category" class="custom-select">

                        <!-- category selection -->
                        <xsl:for-each select="categories/category">
                          <option value="{@id}">
                            <xsl:value-of select="."/>
                          </option>
                        </xsl:for-each>

                      </select>
                    </div>
                    <div class="form-group">
                      <input required="required" class="form-control" type="datetime-local" name="due" value="2020-01-01T12:00" min="2018-06-07T00:00" max="2025-06-14T00:00" pattern="[0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2}"/>
                    </div>
                    <button class="form-control" type="submit">Add task</button>
                  </form>
                </div>
              </div>
            </div>

          </div>
        </div>
        <script src="https://kit.fontawesome.com/95c260002a.js" crossorigin="anonymous"></script>
        <script src="https://code.jquery.com/jquery-3.2.1.slim.min.js" integrity="sha384-KJ3o2DKtIkvYIK3UENzmM7KCkRr/rE9/Qpg6aAZGJwFDMVNA/GpGFF93hXpG5KkN" crossorigin="anonymous"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.12.9/umd/popper.min.js" integrity="sha384-ApNbgh9B+Y1QKtv3Rn7W3mgPxhU9K/ScQsAP7hUibX39j7fakFPskvXusvfa0b4Q" crossorigin="anonymous"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/js/bootstrap.min.js" integrity="sha384-JZR6Spejh4U02d8jOt6vLEHfe/JQGiRRSQQxSfFWpi1MquVdAyjUar5+76PVCmYl" crossorigin="anonymous"></script>
      </body>
    </html>

  </xsl:template>
</xsl:stylesheet>