library(shiny)

#Define UI for anova
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("Dynamic"),

  # Sidebar with controls to select the variable to plot against mpg
  # and to specify whether outliers should be included
  sidebarPanel(
    checkboxInput("smooth", "Smooth"),
    conditionalPanel(
      condition = "input.smooth == true",
      selectInput("smoothMethod", "Method",
                  list("lm", "glm", "gam", "loess", "rlm"))
    ),
    br(),
    selectInput("dataset", "Dataset", c("diamonds", "rock", "pressure", "cars")),
    conditionalPanel(
      condition = "output.nrows",
      checkboxInput("headonly", "Only use first 1000 rows")
    ),
    br(),
    numericInput("lat", "Latitude", NA),
    numericInput("long", "Longitude", NA),
    uiOutput("cityControls")    
  ),

  mainPanel(



  )

))
