curve( sqrt(x)
       , from = 0
       , to = 5
       , col = "red" # colors the outline of hollow symbol pch=21
       , xlab = "x"
       , ylab = "y"
)
curve( log(2*x)
       , from = 0
       , to = 5
       , col = "blue"
       , add = TRUE
)
curve( log(x+1)
       , from = 0
       , to = 5
       , col = "yellow"
       , add = TRUE
)
curve( log(x+0.5)
       , from = 0
       , to = 5
       , col = "green"
       , add = TRUE
)
legend( "topleft"
        , legend = c("sqrt(x)", "log(2*x)", "log(x+1)", "log(x+0.5)"),
        , col = c("red", "blue", "yellow", "green"), 
        , pt.bg = c("red","blue", "yellow", "green")
        , pch = c(21,22)
)

0.2 + 0.16*log(2*5/1)
0.16 * log((5+0.5*1)/1)
0.2 + 0.16*log((5 + 1)/1)
0.2 + 0.16*sqrt(5/1)
