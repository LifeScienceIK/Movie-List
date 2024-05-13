library(shiny)
library(tidyverse)
library(bslib)
library(shinyWidgets)
source('helpers.R')
movie_df <- read.csv('unseen_movies.csv')
seen_movies <- read.csv('seen_movies.csv', 
                 colClasses = c('character', 'integer', 'character'))
movie_sel <- as.character(read.csv(
  'selected_movie.csv', header = FALSE, skip = 1))

ui <- page_sidebar(title = 'Movie List',
  sidebar = sidebar('User interface',
                    textInput('movie_name', 
                              label = "Enter the title to add",
                              value = ''),
                    textInput('movie_year',
                              label = 'Enter the production year',
                              value = ''),
                    actionButton('submit', label = 'Add film'),
                    br(), br(),
                    selectInput(
                      'table_type',
                      label = 'Choose table',
                      choices = c('Unseen movies',
                                  'Seen movies'),
                      selected = 'Unseen movies'
                    ),
                    br(),
                    "Random movie",
                    actionButton('random', 
                                 label = 'Draw random movie'),
                    textOutput('selected'),
                    actionButton('move_to',
                                 label = 'Move movie to seen'),
                    br(), br(), br(),
                    actionButton('save', label = 'Save changes')),
  card(card_header(textOutput("card_header")),
    card_body(tableOutput('table'))
  )
)

server <- function(input, output) {
  #defining reactive values
  movies <- reactiveVal(movie_df)
  seen <- reactiveVal(seen_movies)
  selected_movie <- reactiveVal(movie_sel)
  
  #functions reacting to user actions
  observeEvent(input$submit, {
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
    movie <- sample(movies()[[1]], 1)
    selected_movie(movie)
  })
  observeEvent(input$move_to, {
    moved = move_to_watched(selected_movie(), movies(), seen())
    movies(moved[[2]])
    seen(moved[[1]])
    selected_movie('No movie selected')
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
  output$table <- renderTable({
    if (input$table_type == 'Unseen movies') {
      movies()
    } else {
      seen()
    }
  })
  output$selected <- renderText({
    selected_movie()
  })
}

shinyApp(ui = ui, server = server)