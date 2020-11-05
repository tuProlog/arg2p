r0 : [] => a('Pippo'). 
r1 : [] => b('Pippo').
r2 : [] => -a('Pippo').

r3 : [] :> sup(r1, r0).
r4 : [] :> sup(r2, r1).

r5 : [] => sup(r0, r2).

t1: sup(Y, X), sup(Z, Y), prolog(Z \== X) :> sup(Z, X).

graphBuildMode(base).
statementLabellingMode(base).
argumentLabellingMode(grounded).

t2: sup(Y, X), -sup(Z, X) :> -sup(Z, Y). // USELESS
t3: sup(Z, Y), -sup(Z, X) :> -sup(Y, X). // USELESS
t4: sup(Y, X) :> -sup(X, Y) // USELESS
