library(shiny)
library(RPostgreSQL)

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {

  output$dblistTablesControls <- reactiveUI(function() {
    tbls <- dbListTables(datasetInput())
    selectInput("dbtable", "Select table:", tbls)
  })

  datasetInput <- reactive(function() {
    user <- input$dbuser
    pwd <- input$dbpass

    con <- dbConnect(PostgreSQL(), user=user, dbname=user, password=pwd, host="localhost")
    con
  })

  activeTable <- reactiveUI(function() {
    input$dbtable
  })

  isActiveDB <- reactive(function() {
    RPostgreSQL::isPostgresqlIdCurrent(datasetInput())
  })
  
    # Generate a summary of the dataset
  output$summary <- reactivePrint(function() {
    if(length(activeTable())> 0) {
      dataset <- dbReadTable(conn=datasetInput(), name=activeTable())
      summary(dataset)
    }
  })
  
  # Show the first "n" observations
  output$view <- reactiveTable(function() {
    if(length(activeTable()) > 0) {
      head(dbReadTable(conn=datasetInput(), name=activeTable()))
    }
  })


  output$contents <- reactive(function() {
    u <- input$dbuser
    p <- input$dbpass
    sprintf("Connecting to DB[%s] with credentials [user=%s,password=%s]", u, u, p) 
  })
 

#  output$cityControls <- reactiveUI(function() {
#     cities <- getNearestCities(input$lat, input$long)
#     checkboxGroupInput("cities", "Choose Cities", cities)
#    if(nrow(datasetInput()) > 0) {
#      checkboxGroupInput("cities", "Choose Cities", datasetInput())
#    }     
#  })
})

