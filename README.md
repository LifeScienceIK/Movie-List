# Movie List
I am currently developping a Shiny App to keep a watch list, draw random movies from the list and move watched movies to a different list.
## Description of the app
Below, you can find a description of the main features of the app.
### Adding movies
The user can currently add movies to the watch list by typing movie titles and production years in the corresponding fields on the interface panel. Once they click on the "Add" button, the app checks if the year input is correct and adds the movie to the dataframe.
### Tables
Both the watch list and seen movies are shown on the main page of the app.
### Drawing a random movie
By clicking on the button "Draw random movie" the user can ask the program to select a movie from the list. The title of the movie is then displayed just below and can be moved to the seen list by clicking on "Move movie to seen".
The user can also select a movie from the watch list manually to then move it to the seen list or to delete it from the watch list.
### Saving changes
Once the user has added new titles and/or moved movies to the seen list, they must click on the "Save changes" buttons to update the csv files containing the two lists and the last random movie drawn by the app.

## Design
In the last version of the app, the design has been updated. I applied a preset theme using the bs_themer and then modified the display of the titles on the sidebar with html tags.
