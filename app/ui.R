#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Notes with autocompletion."),
  br(),
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      # Copy the line below to make a text input box
      textAreaInput("text", label = h4("Text input"), height = '100px', placeholder = "write your post here."),
      helpText("You can select the next word you'd like to add among below prediction words."),
      tags$div(id="button-container",
               uiOutput("predictionButtons")
      ),
      hr(),
      
      actionButton("post", label = "Post"),
      actionButton("clear", label = "Clear")
    ),
    
    mainPanel(
      tableOutput("value")
    )
  )
))
