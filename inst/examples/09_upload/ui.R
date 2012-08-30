library(shiny)

shinyUI(pageWithSidebar(
  headerPanel("File Upload"),
  sidebarPanel(
    tags$input(id='file1', type='file')
  ),
  mainPanel()
))