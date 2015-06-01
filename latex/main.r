##################
# Load Libraries #
##################
library(DBI)
library(RMySQL)
library(ggplot2)
require(gridExtra)

###########
# Cleanup #
###########
rm(list = ls())
graphics.off()

####################
# Import Test Data #
####################
options(warn=-1)
connection = dbConnect(dbDriver("MySQL"), user="root", password="toor", host="127.0.0.1", dbname="bachelor_test")
# Persons
result = dbSendQuery(connection, "SELECT * FROM person")
test_persons = dbFetch(result, n=-1)
dbClearResult(result)
# Tasks
result = dbSendQuery(connection, "SELECT * FROM task")
test_tasks = dbFetch(result, n=-1)
dbClearResult(result)
# Points
result = dbSendQuery(connection, "SELECT * FROM point")
test_points = dbFetch(result, n=-1)
dbClearResult(result)
dbDisconnect(connection)
options(warn=0)

#####################
# Import Final Data #
#####################
options(warn=-1)
connection = dbConnect(dbDriver("MySQL"), user="root", password="toor", host="127.0.0.1", dbname="bachelor_final")
# Persons
result = dbSendQuery(connection, "SELECT * FROM person")
final_persons = dbFetch(result, n=-1)
dbClearResult(result)
# Tasks
result = dbSendQuery(connection, "SELECT * FROM task")
final_tasks = dbFetch(result, n=-1)
dbClearResult(result)
# Points
result = dbSendQuery(connection, "SELECT * FROM point")
final_points = dbFetch(result, n=-1)
dbClearResult(result)
dbDisconnect(connection)
options(warn=0)

###############
# Filter Data #
###############
filter = function(tasks) {
  limit_upper = mean(tasks$time) + sd(tasks$time) * 3
  limit_lower = mean(tasks$time) - sd(tasks$time) * 3
  subset(tasks, tasks$time >= limit_lower & tasks$time <= limit_upper)
}
test_tasks_filtered = rbind(
  filter(test_tasks[test_tasks$type == "navigating",]),
  filter(test_tasks[test_tasks$type == "spiraling",]),
  filter(test_tasks[test_tasks$type == "pointing",]))
final_tasks_filtered = rbind(
  filter(final_tasks[final_tasks$type == "navigating",]),
  filter(final_tasks[final_tasks$type == "spiraling",]),
  filter(final_tasks[final_tasks$type == "pointing",]))

#################
# Define Models #
#################
# Fitts'
data = final_tasks_filtered[final_tasks_filtered$type == "pointing",]
data$id = log2((2 * data$distance) / (data$width))
model_fitt = lm(time ~ id, data)
remove(data)
# Welford's
data = final_tasks_filtered[final_tasks_filtered$type == "pointing",]
data$id = log2((data$distance + 0.5 * data$width) / (data$width))
model_welford = lm(time ~ 0 + id, data)
remove(data)
# MacKenzie's
data = final_tasks_filtered[final_tasks_filtered$type == "pointing",]
data$id = log2((data$distance + data$width) / (data$width))
model_mackenzie = lm(time ~ id, data)
remove(data)
# Meyer's
data = final_tasks_filtered[final_tasks_filtered$type == "pointing",]
data$id = sqrt((data$distance) / (data$width))
model_meyer = lm(time ~ id, data)
remove(data)

####
# Plot Unfiltered/Filtered Comparison #
####
# Unfiltered Samples
data = test_tasks[test_tasks$type == "pointing" & test_tasks$person == 8,]
data$id = log2((2 * data$distance) / (data$width))
model_fitt_test = lm(time ~ id, data)
ggplot(model_fitt_test, aes(x = id, y = time)) + 
  geom_point() + stat_smooth(method = "lm", formula = y ~ x, se = F) + labs(title = "Testperson 8")
# ggsave(file = "images/plots/plot_model_test_1.png")
remove(data, model_fitt_test)
data = test_tasks[test_tasks$type == "pointing" & test_tasks$person == 11,]
data$id = log2((2 * data$distance) / (data$width))
model_fitt_test = lm(time ~ id, data)
ggplot(model_fitt_test, aes(x = id, y = time)) + 
  geom_point() + stat_smooth(method = "lm", formula = y ~ x, se = F) + labs(title = "Testperson 11")
# ggsave(file = "images/plots/plot_model_test_2.png")
remove(data, model_fitt_test)
# Unfiltered
data = test_tasks[test_tasks$type == "pointing" & test_tasks$person == 15,]
data$id = log2((2 * data$distance) / (data$width))
model_fitt_test = lm(time ~ id, data)
ggplot(model_fitt_test, aes(x = id, y = time)) + 
  geom_point() + stat_smooth(method = "lm", formula = y ~ x, se = F) + labs(title = "Testperson 15 - Ufiltreret")
# ggsave(file = "images/plots/plot_model_test_comparison_unfiltered.png")
remove(data, model_fitt_test)
# Filtered
data = test_tasks_filtered[test_tasks_filtered$type == "pointing" & test_tasks_filtered$person == 15,]
data$id = log2((2 * data$distance) / (data$width))
model_fitt_test_filtered = lm(time ~ id, data)
ggplot(model_fitt_test_filtered, aes(x = id, y = time)) + 
  geom_point() + stat_smooth(method = "lm", formula = y ~ x, se = F) + labs(title = "Testperson 15 - Filtreret")
# ggsave(file = "images/plots/plot_model_test_comparison_filtered.png")
remove(data, model_fitt_test_filtered)

###################
# Calculate AIC's #
###################
print(paste("Fitts' AIC", "=", AIC(model_fitt), sep = " "))
print(paste("Welford's AIC", "=", AIC(model_welford), sep = " "))
print(paste("MacKenzie's AIC", "=", AIC(model_mackenzie), sep = " "))
print(paste("Meyer's AIC", "=", AIC(model_meyer), sep = " "))

###############
# Plot Models #
###############
# Fitts'
ggplot(model_fitt, aes(x = id, y = time)) + 
  geom_point() + stat_smooth(method = "lm", formula = y ~ x, se = F)
# ggsave(file = "images/plots/plot_model_fitt.png")
# Welford's
ggplot(model_fitt, aes(x = id, y = time)) + 
  geom_point() + stat_smooth(method = "lm", formula = y ~ 0 + x, se = F)
# ggsave(file = "images/plots/plot_model_welford.png")
# MacKenzie's
ggplot(model_fitt, aes(x = id, y = time)) + 
  geom_point() + stat_smooth(method = "lm", formula = y ~ x, se = F)
# ggsave(file = "images/plots/plot_model_mackenzie.png")
# Meyer's
ggplot(model_fitt, aes(x = id, y = time)) + 
  geom_point() + stat_smooth(method = "lm", formula = y ~ x, se = F)
# ggsave(file = "images/plots/plot_model_meyer.png")

##################
# Plot Residuals #
##################
# Fitts'
ggplot(model_fitt, aes(x = .fitted, y = .resid)) +
  geom_hline(yintercept = 0, alpha = 0.75, color = "red") +
  geom_point() + geom_smooth(se = F) +
  labs(title = "Fitts's Residualplot", x = "Fittet", y = "Residualer")
# ggsave(file = "images/plots/plot_residual_fitt.png")
# Welford's
ggplot(model_welford, aes(x = .fitted, y = .resid)) +
  geom_hline(yintercept = 0, alpha = 0.75, color = "red") +
  geom_point() + geom_smooth(se = F) +
  labs(title = "Welford's Residualplot", x = "Fittet", y = "Residualer")
# ggsave(file = "images/plots/plot_residual_welford.png")
# MacKenzie's
ggplot(model_mackenzie, aes(x = .fitted, y = .resid)) +
  geom_hline(yintercept = 0, alpha = 0.75, color = "red") +
  geom_point() + geom_smooth(se = F) +
  labs(title = "MacKenzie's Residualplot", x = "Fittet", y = "Residualer")
# ggsave(file = "images/plots/plot_residual_mackenzie.png")
# Meyer's
ggplot(model_meyer, aes(x = .fitted, y = .resid)) +
  geom_hline(yintercept = 0, alpha = 0.75, color = "red") +
  geom_point() + geom_smooth(se = F) +
  labs(title = "Meyer's Residualplot", x = "Fittet", y = "Residualer")
# ggsave(file = "images/plots/plot_residual_meyer.png")
