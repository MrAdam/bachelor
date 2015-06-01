# Load required libraries
library(DBI)
library(RMySQL)
library(ggplot2)
library(grid)
library(gridExtra)

# Load data from database
options(warn=-1);
connection <-dbConnect(dbDriver("MySQL"), user="root", password="toor", host="127.0.0.1", dbname="test")
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
tasks <- subset(tasks, type == "pointing")
limit <- sd(tasks$time) * 3
tasks  <- subset(tasks, tasks$time > 0 & tasks$time <= limit)
points <- subset(points, points$task %in% tasks$id)

# Calculate the elapsedDistance
points$elapsedDistance = 0
points$speed = 0
for (m_task in tasks$id) {
  m_points <- subset(points, points$task == m_task)
  for (point in m_points$id) {
    if (match(point, m_points$id) != 1) {
      prev_dst <- points[points$id == point - 1,]$elapsedDistance
      delta_dst <- points[points$id == point,]$deltaDistance
      points[points$id == point,]$elapsedDistance <- prev_dst + delta_dst
      points[points$id == point,]$speed <- (delta_dst/points[points$id == point,]$deltaTime)
    }
  }
}

# Calculate the deltaX and deltaY
points$deltaX = 0
points$deltaY = 0
points$angleToNext = 0
points$angleToEnd = 0
for (m_task in tasks$id) {

  m_points <- subset(points, points$task == m_task)
  end_x <- tail(m_points, n=1)$x
  end_y <- tail(m_points, n=1)$y
  for (point in m_points$id) {
    if (match(point, m_points$id) != 1) {
      prev_x <- points[points$id == point - 1,]$x
      prev_y <- points[points$id == point - 1,]$y
      curr_x <- points[points$id == point,]$x
      curr_y <- points[points$id == point,]$y
      points[points$id == point,]$deltaX <- curr_x - prev_x
      points[points$id == point,]$deltaY <- curr_y - prev_y
      points[points$id == point-1,]$angleToNext <- atan2(points[points$id == point,]$deltaY, points[points$id == point,]$deltaX)
      points[points$id == point,]$angleToEnd <- atan2(end_y - curr_y, end_x - curr_x)
    }
  }
}

# OMREGNING AF PIXELS/MILISEC TIL CM/SEC -> X/3.7795
# Plot the data
plot1 <- ggplot(subset(points, task == 14), aes(x = elapsedTime, y = deltaDistance)) + geom_point() + coord_fixed(ratio=4)
print(plot1)

plot2 <- ggplot(subset(points, task == 14), aes(x = x, y = y)) + 
  geom_segment(aes(xend = x + cos(angleToNext)*speed*10, yend = y + sin(angleToNext)*speed*10), arrow = arrow(length = unit(0.2, "cm"))) + 
  coord_fixed(ratio=1)
print(plot2)

plot3 <- ggplot(subset(points, task == 14), aes(x = x, y = y)) + 
  geom_segment(aes(xend = x + cos(angleToEnd)*speed*10, yend = y + sin(angleToEnd)*speed*10), arrow = arrow(length = unit(0.2, "cm"))) + 
  coord_fixed(ratio=1)
print(plot3)
