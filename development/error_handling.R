library(lubridate)

result <- function(var) tryCatch(as.integer(var),
         error = function(e) {
           message("You didn't provide a correct year")},
         warning = function(w) {
           return("You didn't provide a correct year")})

year <- result('text')

                                