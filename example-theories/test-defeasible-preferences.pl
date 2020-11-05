r0 : [] => a('Pippo'). 
r1 : [] => b('Pippo').
r2 : [] => -a('Pippo').

r3 : [] => sup(r1, r0).
r4 : [] => sup(r2, r1).

t1: sup(Y, X), sup(Z, Y) => sup(Z, X).
t2: sup(Y, X), -sup(Z, X) => -sup(Z, Y).
t3: sup(Z, Y), -sup(Z, X) => -sup(Y, X).
t4: sup(Y, X) => -sup(X, Y).

graphBuildMode(base).
statementLabellingMode(base).
argumentLabellingMode(grounded_defeasible_preferences).

r0 : [] => a('Pippo'). 
r1 : [] => b('Pippo').
r2 : [] => -a('Pippo').

r3 : [] :> sup(r1, r0).
r4 : [] :> sup(r2, r1).

r5 : [] => sup(r0, r2).

t1: sup(Y, X), sup(Z, Y) :> sup(Z, X).
t2: sup(Y, X), -sup(Z, X) :> -sup(Z, Y). // USELESS
t3: sup(Z, Y), -sup(Z, X) :> -sup(Y, X). // USELESS
t4: sup(Y, X) :> -sup(X, Y) // USELESS

graphBuildMode(base).
statementLabellingMode(base).
argumentLabellingMode(grounded).
