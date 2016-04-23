library(shiny)

shinyServer(function(input, output, clientData, session) {
  model <- NULL

  getPredictions <- function(model, words) {
    res <- model[[paste(words[[1]], words[[2]])]]
    Filter(function(x) x != 'END' && x != 'UNK', res)
  }

  tokenize <- function(line) {
    words <- Filter(function(w) nchar(w) > 0, strsplit(tolower(gsub('\\W|\\d|_', ' ', line)), '\\s+')[[1]])
  }

  observeEvent(input$select, updateTextInput(session, 'text', value=paste(gsub('\\s+$', '', input$text), input$predictions, sep = ' ')))

  updatePredictions <- function(text) {
    withProgress(message ='loading', detail='...', value=0, {
      if(is.null(model)) model <<- readRDS('model.dat')
      words <- tokenize(text)
      if(length(words) > 0) {
        if (length(words) == 1) {
          words <- c('START', words)
        }

        updateSelectInput(session, 'predictions', choices = getPredictions(model, words[(length(words)-1):length(words)]), selected = '')
      } else {
        updateSelectInput(session, 'predictions', choices = list(), selected = '')
      }
      setProgress(value=1)
    })
  }

  observeEvent(input$text, {
   updatePredictions(input$text)
  })

  observeEvent(input$search, {
    updatePredictions(input$text)
  })

  output$preview <- renderText(input$text)
})
