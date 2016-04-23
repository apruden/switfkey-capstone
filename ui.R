library(shiny)
library(shinyjs)

jscode <- "shinyjs.init = function() {
  $('#predictions').keypress(function(e) {
    var charCode = e.which || e.keyCode;

    if ([13, 27].indexOf(charCode) > -1) {
      $(this).val('');
      if (charCode === 13) $('#select').click();
      $('#text').focus();
      return false;
    }
  });

  $('#text').focus(function() {
    this.selectionStart = this.selectionEnd = this.value.length;
  });

  $('#text').attr('autocomplete', 'off');
}"

shinyUI(fluidPage(
  includeCSS('www/main.css'),
  useShinyjs(),
  extendShinyjs(text = jscode, functions=c('init')),
  titlePanel('Swiftkey Capstone'),
    verticalLayout(
      helpText(paste('Enter some text in the input box and predictions will be shown in the select area',
                 'below. You can press <enter> or click the "Select" button to select one of the suggestions.')),
      tags$div(class="form-group shiny-input-container",tags$textarea(id="text", rows=3, class="form-control","")),
      actionButton("search", "Search"),
      selectInput("predictions", label="", choices = list(), selected = '', multiple = F, size=10, selectize = F),
      actionButton("select", "Select"),
      br(),
      wellPanel(
        h4('Preview:'),
        textOutput("preview")
      )
    )
))
