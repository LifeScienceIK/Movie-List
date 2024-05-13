setwd('C:/Users/33768/Documents/R scripts/Shiny_apps/movieList')
library(tidyverse)
library(shiny)
source('helpers.R')
names <- c('Godzilla minus One', 'Dune 2', 'Oppenheimer')
years <- c(2024, 2024, 2023)

# Functions to read an write into the files
m <- read.csv('unseen_movies.csv')
write.csv(movies, file = 'unseen_movies.csv', row.names = FALSE)

s <- read.csv('seen_movies.csv', 
                        colClasses = c('character', 'numeric', 'Date'))
write.csv(seen_movies, file = 'seen_movies.csv',  row.names = FALSE)

#Function that moves movies from one list to the other
move_to_watched <- function(movie_name) {
  index <- which(movies[1] == movie_name)
  movie <- movies[index, ]
  movie['Date_added'] = Sys.Date()
  seen_movies <<- seen_movies %>%
    add_row(movie)
  movies <<- movies[-index, ]
}


new_movie <- data.frame('title' = 'gdhdhdh', 'year' = as.numeric('1942'))
class(as.numeric(1942))
add_row(movies, new_movie)
write.csv(movies, 'selected_movie.csv', row.names = FALSE)
as.character(read.csv('selected_movie.csv', header = FALSE, skip = 1))



moved <- move_to_watched('Dune 2', m, s)
moved[[1]]

format(Sys.Date(),'%Y-%m-%d')
