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
        <header class="text-center">
          <h2>Task tracker</h2>
          <h3> Keep track of all your tasks! </h3>
        </header>
        <div class="container">
          <div class="row justify-content-center">
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
                      <xsl:apply-templates select="categories"/>
                    </div>
                  </div>
                </li>
                <li class="nav-item">
                  <button class="btn btn-link" type="button" data-toggle="collapse" data-target="#collapseCatForm" aria-expanded="false" aria-controls="collapseCatForm">Add category</button>
                  <div class="collapse" id="collapseCatForm">
                    <div class="card card-body">
                      <form action="/addcategory" method="post">
                        <div class="form-group">
                          <input type="text" class="form-control" name="category" placeholder="Enter category name" />
                        </div>
                        <button class="form-control" type="submit">Add category</button>
                      </form>
                    </div>
                  </div>
                </li>
              </ul>
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

  <!-- category nav item -->
  <xsl:template match="category">
    <div class="row category-row">
      <div class="col-9 d-flex align-items-center p-0">
        <a class="dropdown-item" href="/categories/{@id}">
          <xsl:apply-templates/>
        </a>
      </div>
      <div class="col-3 d-flex flex-row justify-content-end align-items-center">
        <form action="/deletecategory" method="post">
          <input type="hidden" value="{@id}" name="id" />
          <button type="submit" class="btn btn-primary">X</button>
        </form>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>