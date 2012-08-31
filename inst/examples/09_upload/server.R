library(shiny)

shinyServer(function(input, output) {
  output$contents <- reactive(function() {
    inFile <- input$file1
    if (is.null(inFile))
      return()
    
    readChar(inFile[1], file.info(inFile[1])$size)
  })
})