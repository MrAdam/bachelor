curve(sqrt(x), from=0, to=5, main='title', ylab='ID', xlab='A/W', col='red')
curve(log(x+1), add=TRUE, col='blue')
curve(log(2*x), add=TRUE, col='yellow')
curve(log(x+0.5), add=TRUE)

0.2 + 0.16*log(2*5/1)
0.16 * log((5+0.5*1)/1)
0.2 + 0.16*log((5 + 1)/1)
0.2 + 0.16*sqrt(5/1)
