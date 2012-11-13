library(shiny)

passwordInput <- function(inputId, label) {
  tagList(tags$label(label), tags$input(id = inputId, type = "password", value = ""))
}

#Define UI for anova
shinyUI(pageWithSidebar(

  # Application title
  headerPanel("DB List"),

  # Sidebar with controls to select the variable to plot against mpg
  # and to specify whether outliers should be included
  sidebarPanel(
    textInput("dbuser", "Username:", Sys.getenv("USER")),
    textInput("dbpass", "Password:"),

    submitButton("Update View"),
    
#    checkboxInput("listTables", "List Tables?"),
#    conditionalPanel(
#      condition = "input.listTables == true",
#      uiOutput("dblistTablesControls")
#     ),
    br(),
    uiOutput("dblistTablesControls")
  ),

 mainPanel(
    tabsetPanel(
      tabPanel("Summary", verbatimTextOutput("summary")), 
      tabPanel("Table", tableOutput("view")),
      tabPanel("Connection", textOutput("contents"))
    )
  )


  
))
