library(shiny)
library(RPostgreSQL)

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {

  output$dblistTablesControls <- reactiveUI(function() {
    if (isActiveDB()) {
      con <- datasetInput()
      tbls <- dbListTables(con)
      selectInput("dbtable", "Select table:", tbls)
#       dbDisconnect(con)
    }
  })

  datasetInput <- reactive(function() {
    user <- input$dbuser
    pwd <- input$dbpass
    tryCatch(con <- dbConnect(PostgreSQL(), user=user, dbname=user, password=pwd, host="localhost"),  
             error = function(e) e)
    con
  })

  activeTable <- reactiveUI(function() {
    input$dbtable
  })
  
  isActiveConn <- reactive(function() {
    dpg <- dbDriver("PostgreSQL")
    ifelse(dbListConnections(dpg) > 0, TRUE, FALSE)
  })

  isActiveDB <- reactive(function() {
    con <- datasetInput()
    RPostgreSQL::isPostgresqlIdCurrent(con)
#     dbDisconnect(con)
  })
  
    # Generate a summary of the dataset
  output$summary <- reactivePrint(function() {
    if(length(activeTable())> 0) {
      con <- datasetInput()
      dataset <- dbReadTable(conn=con, name=activeTable())
      summary(dataset)
    }
#     dbDisconnect(con)
  })
  
  # Show the first "n" observations
  output$view <- reactiveTable(function() {
    if(length(activeTable()) > 0) {
      con <- datasetInput()
      dbReadTable(conn=con, name=activeTable())
    }
#     dbDisconnect(con)
  })


  output$contents <- reactiveUI(function() {
    u <- input$dbuser
    p <- input$dbpass
    sprintf("Connected to Database [ %s ] with credentials [ user=%s, passwd=%s ]", u, u, p) 
  })
 

#  output$cityControls <- reactiveUI(function() {
#     cities <- getNearestCities(input$lat, input$long)
#     checkboxGroupInput("cities", "Choose Cities", cities)
#    if(nrow(datasetInput()) > 0) {
#      checkboxGroupInput("cities", "Choose Cities", datasetInput())
#    }     
#  })
})

