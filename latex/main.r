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
connection = dbConnect(dbDriver("MySQL"), user="root", host="127.0.0.1", dbname="bachelor_tests")
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
connection = dbConnect(dbDriver("MySQL"), user="root", host="127.0.0.1", dbname="bachelor_final")
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
#    Pointing   #
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

#######################################
# Plot Unfiltered/Filtered Comparison #
#######################################
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
#     Pointing    #
###################
print(paste("Fitts' AIC", "=", AIC(model_fitt), sep = " "))
print(paste("Welford's AIC", "=", AIC(model_welford), sep = " "))
print(paste("MacKenzie's AIC", "=", AIC(model_mackenzie), sep = " "))
print(paste("Meyer's AIC", "=", AIC(model_meyer), sep = " "))

###############
# Plot Models #
###############
#   Pointing  #
###############
# Fitts'
ggplot(model_fitt, aes(x = id, y = time)) + 
  geom_point() + stat_smooth(method = "lm", formula = y ~ x, se = F)
#  ggsave(file = "images/plots/plot_model_fitt.png")
# Welford's
ggplot(model_welford, aes(x = id, y = time)) + 
  geom_point() + stat_smooth(method = "lm", formula = y ~ 0 + x, se = F)
#  ggsave(file = "images/plots/plot_model_welford.png")
# MacKenzie's
ggplot(model_mackenzie, aes(x = id, y = time)) + 
  geom_point() + stat_smooth(method = "lm", formula = y ~ x, se = F)
#  ggsave(file = "images/plots/plot_model_mackenzie.png")
# Meyer's
ggplot(model_meyer, aes(x = id, y = time)) + 
  geom_point() + stat_smooth(method = "lm", formula = y ~ x, se = F)
#  ggsave(file = "images/plots/plot_model_meyer.png")

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

######################
# Navigation Example #
######################

data = test_tasks_filtered[test_tasks_filtered$type == "navigating" & test_tasks_filtered$person == 15,]
data$id = data$distance/(8-data$width) * log(8/data$width)
model_accot_test = lm(time ~ id, data)
ggplot(model_accot_test, aes(x = id, y = time)) + 
  geom_point() + stat_smooth(method = "lm", formula = y ~ x, se = F) + labs(title = "Testperson 7")
 ggsave(file = "images/plots/plot_model_test_navigation_1.png")
remove(data, model_accot_test)

data = test_tasks_filtered[test_tasks_filtered$type == "navigating" & test_tasks_filtered$person == 17,]
data$id = data$distance/(8-data$width) * log(8/data$width)
model_accot_test = lm(time ~ id, data)
ggplot(model_accot_test, aes(x = id, y = time)) + 
  geom_point() + stat_smooth(method = "lm", formula = y ~ x, se = F) + labs(title = "Testperson 9")
 ggsave(file = "images/plots/plot_model_test_navigation_2.png")
remove(data, model_accot_test)

########################
#  Navigating Models   #
########################
# Fitts'
data = final_tasks_filtered[final_tasks_filtered$type == "navigating",]
id = log2((2 * data$distance) / (8))
time <- data$time
df <- data.frame(id, time)
datamean_fitt <- aggregate(.~id, data=df, mean)
model_fitt_navigating = lm(datamean_fitt[,2] ~ datamean_fitt[,1])
remove(data)
# Welford's
data = final_tasks_filtered[final_tasks_filtered$type == "navigating",]
id = log2((data$distance + 0.5 * 8) / (8))
time <- data$time
df <- data.frame(id, time)
datamean_welford <- aggregate(.~id, data=df, mean)
model_welford_navigating = lm(datamean_welford[,2] ~ datamean_welford[,1])
remove(data)
# MacKenzie's
data = final_tasks_filtered[final_tasks_filtered$type == "navigating",]
id = log2((data$distance + 8) / (8))
time <- data$time
df <- data.frame(id, time)
datamean_mackenzie <- aggregate(.~id, data=df, mean)
model_mackenzie_navigating = lm(datamean_mackenzie[,2] ~ datamean_mackenzie[,1])
remove(data)
# Meyer's
data = final_tasks_filtered[final_tasks_filtered$type == "navigating",]
id = sqrt((data$distance) / (8))
time <- data$time
df <- data.frame(id, time)
datamean_meyer <- aggregate(.~id, data=df, mean)
model_meyer_navigating = lm(datamean_meyer[,2] ~ datamean_meyer[,1])
remove(data)
# Accot&Zhai's
data = final_tasks_filtered[final_tasks_filtered$type == "navigating",]
id = (data$distance) / (8-data$width) * log(8/data$width)
time <- data$time
df <- data.frame(id, time)
datamean_accot <- aggregate(.~id, data=df, mean)
model_accot_navigating = lm(datamean_accot[,2] ~ datamean_accot[,1])
remove(data)

#######################
#   Navigating AIC    #
#######################
print(paste("Fitts' AIC", "=", AIC(model_fitt_navigating), sep = " "))
print(paste("Welford's AIC", "=", AIC(model_welford_navigating), sep = " "))
print(paste("MacKenzie's AIC", "=", AIC(model_mackenzie_navigating), sep = " "))
print(paste("Meyer's AIC", "=", AIC(model_meyer_navigating), sep = " "))
print(paste("Accot's AIC", "=", AIC(model_accot_navigating), sep = " "))

####################
# Navigating plot  #
####################
# Fitts'
ggplot(model_fitt_navigating, aes(x = datamean_fitt$id, y = datamean_fitt$time)) + 
  geom_point() + stat_smooth(method = "lm", formula = y ~ x, se = F) + labs(title = "Fitts' tunnel model", x = "ID", y = "Time")
#  ggsave(file = "images/plots/plot_model_tunnel_fitt.png")
# Welford's
ggplot(model_welford_navigating, aes(x = datamean_welford$id, y = datamean_welford$time)) + 
  geom_point() + stat_smooth(method = "lm", formula = y ~ 0 + x, se = F) + labs(title = "Welford's tunnel model", x = "ID", y = "Time")
#  ggsave(file = "images/plots/plot_model_tunnel_welford.png")
# MacKenzie's
ggplot(model_mackenzie_navigating, aes(x = datamean_mackenzie$id, y = datamean_mackenzie$time)) + 
  geom_point() + stat_smooth(method = "lm", formula = y ~ x, se = F) + labs(title = "Mackenzie's tunnel model", x = "ID", y = "Time")
#  ggsave(file = "images/plots/plot_model_tunnel_mackenzie.png")
# Meyer's
ggplot(model_meyer_navigating, aes(x = datamean_meyer$id, y = datamean_meyer$time)) + 
  geom_point() + stat_smooth(method = "lm", formula = y ~ x, se = F) + labs(title = "Meyer's tunnel model", x = "ID", y = "Time")
#  ggsave(file = "images/plots/plot_model_tunnel_meyer.png")
# Accot's
ggplot(model_accot_navigating, aes(x = datamean_accot$id, y = datamean_accot$time)) + 
  geom_point() + stat_smooth(method = "lm", formula = y ~ x, se = F) + labs(title = "Accot & zhai's tunnel model", x = "ID", y = "Time")
#  ggsave(file = "images/plots/plot_model_tunnel_accot.png")
##########################################
# Plot individual persons pointing tasks #
##########################################
tasks = final_tasks_filtered[final_tasks_filtered$type == "pointing" & final_tasks_filtered$person == 60,"id"]
points = final_points[final_points$task %in% tasks,]
p = ggplot() + theme(legend.position="none")
for (id in unique(points$task)) {
  temp = points[points$task == id,]
  p = p + geom_path(data = temp, aes(x = x, y = y, colour = id))
}
#ggsave(file = "images/plots/plot_analysis_qualitative.png")

###############
# Lorem Ipsum #
###############
final_points$elapsedDistance = 0
final_points$speed = 0
final_points$angleToNext = 0
final_points$angleToEnd = 0
m_tasks = final_tasks[final_tasks$type == "pointing" & final_tasks$person == 7, "id"]
for (m_task in m_tasks) {
  print(m_task)
  m_points = final_points[final_points$task == m_task,]
  end_x <- tail(m_points, n = 1)$x
  end_y <- tail(m_points, n = 1)$y
  for (m_point in m_points$id[-1]) {
    # Calculate elapsed distance
    prev_dst = final_points[final_points$id == m_point - 1, "elapsedDistance"]
    delta_dst = final_points[final_points$id == m_point, "deltaDistance"]
    final_points[final_points$id == m_point, "elapsedDistance"] = prev_dst + delta_dst
    # Calculate Speed
    final_points[final_points$id == m_point, "speed"] = (delta_dst / final_points[final_points$id == m_point, "deltaTime"])
    # Calculate angle to the next point and angle to the end point
    prev_x = final_points[final_points$id == m_point - 1, "x"]
    prev_y = final_points[final_points$id == m_point - 1, "y"]
    curr_x = final_points[final_points$id == m_point, "x"]
    curr_y = final_points[final_points$id == m_point, "y"]
    delta_x = curr_x - prev_x
    delta_y = curr_y - prev_y
    final_points[final_points$id == m_point - 1, "angleToNext"] = atan2(delta_y, delta_x)
    final_points[final_points$id == m_point, "angleToEnd"] = atan2(end_y - curr_y, end_x - curr_x)
  }
}

#####################################################
# Plot individual persons speed for a specific task #
#####################################################
points1 = subset(final_points, task == 207)
points2 = subset(final_points, task == 213)
points3 = subset(final_points, task == 209)
points4 = subset(final_points, task == 210)
plot1 = ggplot(points1, aes(x = elapsedDistance, y = speed)) + geom_line() + coord_fixed(ratio = 8)
plot2 = ggplot(points2, aes(x = elapsedDistance, y = speed)) + geom_line() + coord_fixed(ratio = 8)
plot3 = ggplot(points3, aes(x = elapsedDistance, y = speed)) + geom_line() + coord_fixed(ratio = 8)
plot4 = ggplot(points4, aes(x = elapsedDistance, y = speed)) + geom_line() + coord_fixed(ratio = 8)
# ggsave(file = "images/plots/plot_speed_individual.png", grob)

#####################
# Plot vector paths #
#####################
data = final_points[final_points$task == 214, c("x", "y", "speed", "angleToNext", "angleToEnd")]
m_plot = ggplot(data, aes(x, y)) + coord_fixed(ratio = 1) +
  geom_segment(aes(xend = x + cos(angleToNext) * speed * 10, yend = y + sin(angleToNext) * speed * 10), arrow = arrow(length = unit(0.2, "cm")))
# ggsave(file = "images/plots/plot_velocity_individual.png")
m_plot = ggplot(data, aes(x, y)) + coord_fixed(ratio = 1) +
  geom_segment(aes(xend = x + cos(angleToEnd) * speed * 10, yend = y + sin(angleToEnd) * speed * 10), arrow = arrow(length = unit(0.2, "cm")))
# ggsave(file = "images/plots/plot_velocity_individual_target.png")
