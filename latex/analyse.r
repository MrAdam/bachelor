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

# Filter out all data, except pointing data
data <- tasks[tasks$type == "pointing" & tasks$time < 3000 & tasks$time != 0, c("distance", "width", "time")];

# Fitt's model
fitt_data <- data;
fitt_data$id <- log2((2 * fitt_data$distance) / (fitt_data$width));
fitt_model <- lm(time ~ id, data = fitt_data);
fitt_plot <- ggplot(data = fitt_model, aes(x = .fitted, y = .resid)) + 
  geom_hline(yintercept=0, alpha=0.75, color="blue") + 
  geom_point() + geom_smooth(se = F, color="red") +
  labs(title="Fitt's Residualplot", x="Fitted", y="Residualer");

# Welford's model
welford_data <- data;
welford_data$id <- log2((welford_data$distance + 0.5 * welford_data$width) / (welford_data$width));
#welford_model <- lm(time ~ 0 + id, data = welford_data);
welford_model <- lm(time ~ id, data = welford_data);
welford_plot <- ggplot(data = welford_model, aes(x = .fitted, y = .resid)) + 
  geom_hline(yintercept=0, alpha=0.75, color="blue") + 
  geom_point() + geom_smooth(se = F, color="red") +
  labs(title="Welford's Residualplot", x="Fitted", y="Residualer");

# MacKenzie's model
mackenzie_data <- data;
mackenzie_data$id <- log2((mackenzie_data$distance + mackenzie_data$width) / (mackenzie_data$width));
mackenzie_model <- lm(time ~ id, data = mackenzie_data);
mackenzie_plot <- ggplot(data = mackenzie_model, aes(x = .fitted, y = .resid)) + 
  geom_hline(yintercept=0, alpha=0.75, color="blue") + 
  geom_point() + geom_smooth(se = F, color="red") +
  labs(title="MacKenzie's Residualplot", x="Fitted", y="Residualer");

# Meyer's model
meyer_data <- data;
meyer_data$id <- sqrt((meyer_data$distance) / (meyer_data$width));
meyer_model <- lm(time ~ id, data = meyer_data);
meyer_plot <- ggplot(data = meyer_model, aes(x = .fitted, y = .resid)) + 
  geom_hline(yintercept=0, alpha=0.75, color="blue") + 
  geom_point() + geom_smooth(se = F, color="red") +
  labs(title="Meyer's Residualplot", x="Fitted", y="Residualer");

# Plots
grid.arrange(fitt_plot, mackenzie_plot, welford_plot, meyer_plot, ncol=2);

# AIC analysis
comparison <- data.frame(Model = c("Fitt's", "Welford's", "MacKenzie's", "Meyer's"), AIC = c(AIC(fitt_model), AIC(welford_model), AIC(mackenzie_model), AIC(meyer_model)));
comparison$order <- reorder(comparison$Model, comparison$AIC);
ggplot(comparison, aes(x = reorder(Model, AIC), y = AIC, color = Model)) + 
  geom_point(aes(size=10)) + 
  labs(title="AIC Analyse", x="Model") + 
  theme(legend.position = "none");
