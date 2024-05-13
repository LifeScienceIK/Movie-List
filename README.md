# Movie List
I am currently developping a Shiny App to keep a watch list, draw random movies from the list and move watched movies to a different list.
## Description of the app
Below, you can find a description of the main features of the app.
### Adding movies
The user can currently add movies to the watch list by typing movie titles and production years in the corresponding fields on the interface panel. Once they click on the "Add" button, the app checks if the year input is correct and adds the movie to the dataframe.
### Switching tables
By using the drop-down menu under the "choose table" title, the user can switch from the watch list to the list of movies they have already seen.
### Drawing a random movie
By clicking on the button "Draw random movie" the user can ask the program to select a movie from the list. The title of the movie is then displayed just below and can be moved to the seen list by clicking on "Move movie to seen".
### Saving changes
Once the user has added new titles and/or moved movies to the seen list, they must click on the "Save changes" buttons to update the csv files containing the two lists and the last random movie drawn by the app.

## Features to be added
I'm currently developing a function that will allow the user to select movies from the list and move them to the seen list without using the random movie function.

## Design
I'm now working on the functional aspects of the app. Its design can be updated, once all the essential features are there and working fine.
