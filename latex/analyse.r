# Load required libraries
library(DBI)
library(RMySQL)
library(ggplot2)
library(grid)
library(gridExtra)

# Load data from database
options(warn=-1);
connection <-dbConnect(dbDriver("MySQL"), user="root", host="127.0.0.1", dbname="bachelor_final");
result <- dbSendQuery(connection, "SELECT * FROM person")
persons <- dbFetch(result, n=-1)
dbClearResult(result)
result <- dbSendQuery(connection, "SELECT * FROM task")
tasks <- dbFetch(result, n=-1)
dbClearResult(result)
result <- dbSendQuery(connection, "SELECT * FROM point")
points <- dbFetch(result, n=-1)
dbClearResult(result)
dbDisconnect(connection)
options(warn=0)

# Filter the data
filter <- function(tasks) {
  limit <- sd(tasks$time) * 3
  subset(tasks, tasks$time > 0 & tasks$time <= limit)
}
tasks_navigating <- filter(tasks[tasks$type == "navigating", c("distance", "width", "time")])
tasks_spiraling <- filter(tasks[tasks$type == "spiraling", c("distance", "width", "time")])
tasks_pointing <- filter(tasks[tasks$type == "pointing", c("distance", "width", "time")])

# Model analysis and plotting
analyse <- function(title, file, data, func, zero = NULL) {
  data$id <- func(data)
  if (is.null(zero)) {
    model <- lm(time ~ id, data = data)
    formula <- y ~ x
  } else {
    model <- lm(time ~ 0 + id, data = data)
    formula <- y ~ 0 + x
  }
  print(paste(title, "AIC", "=", AIC(model), sep = " "))
  ggplot(model, aes(x = id, y = time)) + 
    geom_point() + stat_smooth(method = "lm", formula = formula, se = F)
  ggsave(file = paste("images/plots/plot_model_", file, sep = ""))
  ggplot(data = model, aes(x = .fitted, y = .resid)) +
    geom_hline(yintercept = 0, alpha = 0.75, color = "red") +
    geom_point() + geom_smooth(se = F) +
    labs(title = paste(title, "Residualplot", sep = " "), x = "Fitted", y = "Residualer")
  ggsave(file = paste("images/plots/plot_residual_", file, sep = ""))
}

analyse("Fitt's", "fitt.png", tasks_pointing,
        function(data) log2((2 * data$distance) / (data$width)))
analyse("Welford's", "welford.png", tasks_pointing,
        function(data) log2((data$distance + 0.5 * data$width) / (data$width)), TRUE)
analyse("Welford's Additive", "welford_additive.png", tasks_pointing,
        function(data) log2((data$distance + 0.5 * data$width) / (data$width)))
analyse("MacKenzie's", "mackenzie.png", tasks_pointing, 
        function(data) log2((data$distance + data$width) / (data$width)))
analyse("Meyer's", "meyer.png", tasks_pointing,
        function(data) sqrt((data$distance) / (data$width)))
