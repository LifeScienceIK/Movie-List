move_to_watched <- function(movie_name, movies, seen_movies) {
  index <- which(movies[1] == movie_name)
  movie <- movies[index, ]
  movie['Date_added'] = format(Sys.Date(), '%Y-%m-%d')
  seen <- seen_movies %>%
    add_row(movie)
  unseen <- movies[-index, ]
  list(seen, unseen)
}

delete_movie <- function(movie_name, movies) {
  index <- which(movies[1] == movie_name)
  movies <- movies[-index,]
  movies
}

check_year <- function(var) {
  year <- tryCatch(as.integer(var),
    error = function(e) {
      return("You didn't provide a correct year")},
    warning = function(w) {
      return("You didn't provide a correct year")})
  year > 1900 & year <= as.integer(year(Sys.Date()))
}
