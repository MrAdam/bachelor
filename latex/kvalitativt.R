# Load required libraries
library(DBI);
library(RMySQL);
library(ggplot2);
library(grid);
library(gridExtra)

# Disable warnings temporarily
options(warn=-1);

# Connect to the database
connection <-dbConnect(dbDriver("MySQL"), user="root", password="toor", host="127.0.0.1", dbname="finale");

# Fetch all data from the 'person' table
result <- dbSendQuery(connection, "SELECT * FROM person");
persons <- dbFetch(result, n=-1);
dbClearResult(result);

# Fetch all data from the 'task' table
result <- dbSendQuery(connection, "SELECT * FROM task");
tasks <- dbFetch(result, n=-1);
dbClearResult(result);

# Fetch all data from the 'point' table
result <- dbSendQuery(connection, "SELECT * FROM point");
points <- dbFetch(result, n=-1);
dbClearResult(result);

# Disconnect from the database
dbDisconnect(connection);

# Enable warnings again
options(warn=0);

for (j in 1:60) {
  dataTask <- tasks[tasks$type == "pointing" & tasks$person == 37, c("id", "distance", "width", "time")];
  dataPoints <- points[points$task %in% dataTask$id, c("id","task","x","y")]
  plot(c(0,500),c(0,500))
  for (i in unique(dataPoints$task)) {
    temp = dataPoints[dataPoints$task==i, c("x","y")]
    lines(temp$x, temp$y, col=i)
  }
  print(j)
}