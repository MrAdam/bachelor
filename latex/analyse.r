# Load required libraries
library(DBI);
library(RMySQL);
library(plotrix);
library(ggplot2)

# User-defined functions
qqplot <- function(linearModel, title) {
  y <- quantile(linearModel$resid[!is.na(linearModel$resid)], c(0.25, 0.75));
  x <- qnorm(c(0.25, 0.75));
  slope <- diff(y) / diff(x);
  int <- y[1L] - slope * x[1L];
  plot <- ggplot(linearModel, aes(sample=.resid)) + stat_qq(alpha=0.5) + geom_abline(slope=slope, intercept=int, color="blue") + labs(title=title);
  return(plot);
}

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
ggplot(data = fitt_data, aes(x = id, y = time)) + geom_point() + geom_smooth(method="lm", formula = y ~ x) + labs(title="Fitt's model");
qqplot(fitt_model, "Fitt's QQ-plot");

# Welford's model
welford_data <- data;
welford_data$id <- log2((welford_data$distance + 0.5 * welford_data$width) / (welford_data$width));
welford_model <- lm(time ~ 0 + id, data = welford_data);
ggplot(data = welford_data, aes(x = id, y = time)) + geom_point() + geom_smooth(method="lm", formula = y ~ 0 + x) + labs(title="Welford's model");
qqplot(welford_model, "Welford's QQ-plot");

# MacKenzie's model
mackenzie_data <- data;
mackenzie_data$id <- log2((mackenzie_data$distance + mackenzie_data$width) / (mackenzie_data$width));
mackenzie_model <- lm(time ~ id, data = mackenzie_data);
ggplot(data = mackenzie_data, aes(x = id, y = time)) + geom_point() + geom_smooth(method="lm", formula = y ~ x) + labs(title="MacKenzie's model");
qqplot(mackenzie_model, "MacKenzie's QQ-plot");

# Meyer's model
meyer_data <- data;
meyer_data$id <- sqrt((meyer_data$distance) / (meyer_data$width));
meyer_model <- lm(time ~ id, data = meyer_data);
ggplot(data = meyer_data, aes(x = id, y = time)) + geom_point() + geom_smooth(method="lm", formula = y ~ x) + labs(title="Meyer's model");
qqplot(meyer_model, "Meyer's QQ-plot");

# AIC analysis
x <- c("Fitt's", "Welford's", "MacKenzie's", "Meyer's");
y <- c(AIC(fitt_model), AIC(welford_model), AIC(mackenzie_model), AIC(meyer_model));
ggplot(data = NULL, aes(x=x, y=y, color=x)) + geom_point(aes(size=10)) + labs(title="AIC Analyse", x="Model", y="AIC") + theme(legend.position = "none");
