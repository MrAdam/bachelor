require(ggplot2)

ggplot(data.frame(x=c(0,2)), aes(x)) +
  stat_function(fun=function(x) sqrt(x), aes(color="sqrt(x)")) +
  stat_function(fun=function(x) log(2*x), aes(color="log(2*x)")) +
  stat_function(fun=function(x) log(x+1), aes(color="log(x+1)")) +
  stat_function(fun=function(x) log(x+0.5), aes(color="log(x+0.5)")) +
  xlim(0, 5) + ylim(0, 2.5) + xlab("A/W") + ylab("ID") +
  scale_colour_discrete(name = "Funktion")

ggplot(data.frame(x=c(0,2)), aes(x)) +
  stat_function(fun=function(x) sqrt(x), aes(color="sqrt(x)")) +
  stat_function(fun=function(x) log(2*x), aes(color="log(2*x)")) +
  stat_function(fun=function(x) log(x+1), aes(color="log(x+1)")) +
  stat_function(fun=function(x) log(x+0.5), aes(color="log(x+0.5)")) +
  xlim(0, 100) + xlab("A/W") + ylab("ID") +
  scale_colour_discrete(name = "Funktion")
