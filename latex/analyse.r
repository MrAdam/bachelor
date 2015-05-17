# Load required libraries
library(DBI);
library(RMySQL);
library(plotrix);

# Disable warnings temporarily
options(warn=-1);

# Connect to the database
connection <-dbConnect(dbDriver("MySQL"), user="root", password="toor", host="127.0.0.1", dbname="bachelor_test");

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

# Filter out all data, except pointing data
data <- tasks[tasks$type == "pointing", c("distance", "width", "time")];

# Fitt's model
fitt_data <- data;
fitt_data$id <- log2((2 * fitt_data$distance) / (fitt_data$width));
fitt_model <- lm(time ~ id, data = fitt_data);
layout(matrix(c(1,2,3,4),2,2));
plot(fitt_model);

# Welford's model
welford_data <- data;
welford_data$id <- log2((welford_data$distance + 0.5 * welford_data$width) / (welford_data$width));
welford_model <- lm(time ~ 0 + id, data = welford_data);
layout(matrix(c(1,2,3,4),2,2));
plot(welford_model);

# MacKenzie's model
mackenzie_data <- data;
mackenzie_data$id <- log2((mackenzie_data$distance + mackenzie_data$width) / (mackenzie_data$width));
mackenzie_model <- lm(time ~ id, data = mackenzie_data);
layout(matrix(c(1,2,3,4),2,2));
plot(mackenzie_model);

# Meyer's model
meyer_data <- data;
meyer_data$id <- sqrt((meyer_data$distance) / (meyer_data$width));
meyer_model <- lm(time ~ id, data = meyer_data);
layout(matrix(c(1,2,3,4),2,2));
plot(meyer_model);

# AIC analysis
print(AIC(fitt_model, welford_model, mackenzie_model, meyer_model));
