require(ggplot2)

ggplot(data.frame(x=c(0,2)), aes(x)) +
  stat_function(fun=function(x) sqrt(x), aes(color="sqrt(x) - Meyer")) +
  stat_function(fun=function(x) log2(2*x), aes(color="log(2*x) - Fitts")) +
  stat_function(fun=function(x) log2(x+1), aes(color="log(x+1) - MacKenzie")) +
  stat_function(fun=function(x) log2(x+0.5), aes(color="log(x+0.5) - Welford")) +
  xlim(0, 26) + xlab("A/W") + ylab("ID") +
  scale_colour_discrete(name = "Funktion")

ggplot(data.frame(x=c(0,2)), aes(x)) +
  stat_function(fun=function(x) sqrt(x), aes(color="sqrt(x)")) +
  stat_function(fun=function(x) log2(2*x), aes(color="log(2*x)")) +
  stat_function(fun=function(x) log2(x+1), aes(color="log(x+1)")) +
  stat_function(fun=function(x) log2(x+0.5), aes(color="log(x+0.5)")) +
  xlim(0, 100) + xlab("A/W") + ylab("ID") +
  scale_colour_discrete(name = "Funktion")

0.2 + 0.16 * log2(2*5/1)
0.16 * log2((5+0.5*1)/1)
0.2 + 0.16*log((5+1)/1)
0.2 + 0.16*sqrt(5/1)