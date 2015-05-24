curve( sqrt(x), from=0, to=5, col="red", xlab="A/W", ylab="ID")
curve( log(2*x), col="blue", add=TRUE)
curve( log(x+1), col="yellow", add=TRUE)
curve( log(x+0.5), col="green", add=TRUE)
legend( "topleft", legend=c("sqrt(x)", "log(2*x)", "log(x+1)", "log(x+0.5)"), col=c("red", "blue", "yellow", "green"), pt.bg=c("red","blue", "yellow", "green"), pch=c(21,22))

curve( sqrt(x), from=0, to=100, col="red", xlab="A/W", ylab="ID")
curve( log(2*x), col="blue", add=TRUE)
curve( log(x+1), col="yellow", add=TRUE)
curve( log(x+0.5), col="green", add=TRUE)
legend( "topleft", legend=c("sqrt(x)", "log(2*x)", "log(x+1)", "log(x+0.5)"), col=c("red", "blue", "yellow", "green"), pt.bg=c("red","blue", "yellow", "green"), pch=c(21,22))


0.2 + 0.16*log(2*5/1)
0.16 * log((5+0.5*1)/1)
0.2 + 0.16*log((5 + 1)/1)
0.2 + 0.16*sqrt(5/1)
