library(shiny)
library(tidyverse)
library(bslib)
library(shinyWidgets)
source('helpers.R')

mycss <- "
select ~ .selectize-control .selectize-input {
  max-height: 30px;
  overflow-y: hidden;
}
"

# Reading csv files with data
movie_df <- read.csv('unseen_movies.csv')
seen_movies <- read.csv('seen_movies.csv', 
                 colClasses = c('character', 'integer', 'character'))
movie_sel <- as.character(read.csv(
  'selected_movie.csv', header = FALSE, skip = 1))

# User interface
ui <- page_sidebar(tags$style(mycss),
                  title = 'Movie List',
                   theme = bs_theme(preset = 'united'),
  sidebar = sidebar(tags$div(
                tags$h4('User interface'),
                style = 'text-align: center;
                border: 1px solid black;
                border-radius: 30px;'
                ),
                    textInput('movie_name', 
                              label = tags$div(
                                  "Enter the title to add",
                                  style = 'position: relative;
                                  left: 30px;
                                  font-style: italic;'),
                              value = ''),
                    textInput('movie_year',
                              label = tags$div(class = 'instruction',
                                'Enter the production year',
                                style = 'position: relative;
                                left: 10px;
                                font-style: italic;'),
                              value = ''),
                    actionButton('submit', label = 'Add film'),
                    br(),
                    tags$div(tags$h5("Movie selection"),
                             style = 'text-align: center;'),
                    actionButton('random', 
                                 'Draw random movie'),
                    uiOutput('movie_select'),
                    tags$div(textOutput('selected'),
                             style = 'text-align: center;
                             display: inline-block;
                             white-space: nowrap;
                             overflow: hidden;
                             text-overflow: ellipsis'),
                    actionButton('move_to',
                                 label = 'Move movie to seen'),
                    actionButton('delete',
                                 label = 'Delete from list'),
                    br(), br(),
                    actionButton('save', label = 'Save changes')),
  card(card_header(tags$div(tags$h5("Watch list"),
                            style = 'text-align: center;')),
      card_body(tableOutput('table1'))
  ),
  card(card_header(tags$div(tags$h5("Seen list"),
                            style = 'text-align: center;')),
       card_body(tableOutput('table2'))
       )
)

# Server
server <- function(input, output) {
  #defining reactive values
  movies <- reactiveVal(movie_df)
  seen <- reactiveVal(seen_movies)
  selected_movie <- reactiveVal(movie_sel)
  
  #functions reacting to user actions
  observeEvent(
    req(input$submit, input$movie_name, input$movie_year), {
    if (check_year(input$movie_year)) {
    new_film <- data.frame('Title' = as.character(input$movie_name), 
               'Year' = as.integer(input$movie_year))
    new_df <- add_row(movies(), new_film)
    movies(new_df)
    show_alert(
      title = 'Success',
      text = 'Movie added successfully',
      type = 'success'
    )
    } else {
      show_alert(
      title = 'Wrong input',
      text = "You didn't provide a correct year",
      type = 'error'
      )
    }
  }, ignoreInit = TRUE)
  observeEvent(input$random, {
    if (nrow(movies()) > 0) {
    movie <- sample(movies()[[1]], 1)
    selected_movie(movie)}
  })
  observeEvent(req(!is.null(input$movie_select)), {
    movie <- input$movie_select
    selected_movie(movie)
  }, ignoreInit = TRUE)
  observeEvent(input$move_to, { 
    if (selected_movie() %in% movies()[[1]]) {
    moved = move_to_watched(selected_movie(), movies(), seen())
    movies(moved[[2]])
    seen(moved[[1]])}
  })
  observeEvent(input$delete, {
    if (selected_movie() %in% movies()[[1]]) {
    movies(delete_movie(selected_movie(), movies()))}
  })
  observeEvent(input$save, {
    ask_confirmation(
      inputId = "myconfirmation",
      title = 'Are you sure?',
      btn_labels = c('No', 'Yes')
    )
  })
  observeEvent(input$myconfirmation, {
    write.csv(movies(), file = 'unseen_movies.csv', row.names = FALSE)
    write.csv(seen(), file = 'seen_movies.csv',  row.names = FALSE)
    write.csv(selected_movie(), 'selected_movie.csv', 
              row.names = FALSE)
  })
  
  #Functions rendering output variables
  output$table1 <- renderTable({
      movies()
  })
  output$table2 <- renderTable({
    seen()
  })
  output$selected <- renderText({
    selected_movie()
  })
  output$movie_select <- renderUI({
    selectInput(
      'movie_select',
      label = tags$div(tags$h6('Select manually'),
                       style = 'position: relative;
                       left: 40px'),
      choice = c(movies()$Title),
      selected = NULL)
    })
}

shinyApp(ui = ui, server = server)