#
# This is the server logic of a Shiny web application. You can run the 
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#

library(shiny)
library(data.table)

# Define server logic required to draw a histogram
shinyServer(function(input, output, session) {
  
  freq.dict <-fread("./3gram.csv")
  words= unique(freq.dict[,last.word])
  
  predict <- reactive({
    inputWords <- gsub(",", "", input$text)
    res <- unlist(strsplit(tolower(inputWords), " "))
    if(length(res) < 3) {
      return()
    } else {
      fir <- res[length(res)-2]
      sec <- res[length(res)]
      dummy <- freq.dict[.(fir, sec), on=c("1st.word", "2nd.word")]
      return(head(dummy[, c("last.word", "frequency")],3)[,last.word])
    }
  })
  
  values <- reactiveValues()
  values$terms <- data.frame(Memo = character(),
                             stringsAsFactors = FALSE)
  
  # updated when the user clicks the button
  newEntry <- observeEvent(input$post, {
    values$terms <- rbind(data.frame(stringsAsFactors = FALSE,
                                  Memo = input$text),
                          values$terms)
  })
  
  # added selected prediction to the textAreaInput
  updateTextField <- function(nthPrediction) {
    predictions = predict()
    if (input$text == ""){
      updatedText = paste(predictions[nthPrediction]," ",sep="")
    }
    else{
      predictedWord = paste(paste(" ", predictions[nthPrediction], sep=""), " ", sep="")
      updatedText = gsub("\\s+\\S+(?!\\s)$|\\s+$", predictedWord, input$text, perl=T)
    }
    updateTextInput(session, "text", value = updatedText)
  }
  
  # clear all posts
  clearPost <- observeEvent(input$clear, {
    values$terms <- data.frame(Memo = character(),
                               stringsAsFactors = FALSE)
  })
  
  # show predicted words
  output$predictionButtons <- renderUI({
    predictions = predict()
    if (length(predictions) == 3){
      list(
        actionButton("prediction1", label = predictions[1]),
        actionButton("prediction2", label = predictions[2]),
        actionButton("prediction3", label = predictions[3])
      )
    }
    else if (length(predictions) == 2){
      list(
        actionButton("prediction1", label = predictions[1]),
        actionButton("prediction2", label = predictions[2])
      )
    }
    else if (length(predictions) == 1){
      list(
        actionButton("prediction1", label = predictions[1])
      )
    }
  })
  
  # update textAreaInput
  observeEvent(input$prediction1, {
    updateTextField(1)
  })
  observeEvent(input$prediction2, {
    updateTextField(2)
  })
  observeEvent(input$prediction3, {
    updateTextField(3)
  })
  
  # Generate a summary of the dataset ----
  output$value <- renderTable(
    values$terms, width = "90%"
  )
  
})
