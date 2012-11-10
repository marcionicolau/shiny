library(shiny)

# Define server logic required to plot various variables against mpg
shinyServer(function(input, output) {

  datasetInput <- reactive(function() {
    switch(input$dataset,
           "rock" = rock,
           "pressure" = pressure,
           "cars" = cars,
           "")
  })
  
  output$nrows <- reactive(function() {
    nrow(datasetInput())
  })

  output$cityControls <- reactiveUI(function() {
#     cities <- getNearestCities(input$lat, input$long)
#     checkboxGroupInput("cities", "Choose Cities", cities)
    if(nrow(datasetInput()) > 0) {
      checkboxGroupInput("cities", "Choose Cities", datasetInput())
    }     
  })
})

