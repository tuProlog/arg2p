r0 ~~> a. 
r1 ~~> b.
r2 ~~> -a.

r3 --> sup(r1, r0).
r4 --> sup(r2, r1).

r5 ~~> sup(r0, r2).

t1: sup(Y, X), sup(Z, Y), prolog(Z \== X) :> sup(Z, X).

graphBuildMode(base).
statementLabellingMode(base).
argumentLabellingMode(grounded).
orderingPrinciple(last).
orderingComparator(democrat).