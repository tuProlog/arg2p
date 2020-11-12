r1 : [] :> a.
r2 : a => b.
r3 : b :> c.

r4 : [] :> -c.

graphBuildMode(base).
statementLabellingMode(base).
argumentLabellingMode(grounded).

Caminada 4

f1 --> wr.
f2 --> go.

s1 : b :> -hw.
s2 : m :> hw.

d1 : wr => m.
d2 : go => b.

graphBuildMode(base).
statementLabellingMode(base).
argumentLabellingMode(complete).
orderingPrinciple(last).
orderingComparator(normal).

Caminada 5

f1 --> a.
f2 --> d.
f3 --> c.

s1 : b,e :> -c.

d1 : a => b.
d2 : d => e.

graphBuildMode(base).
statementLabellingMode(base).
argumentLabellingMode(grounded).

Caminada 6

f1 --> a.
f2 --> d.
f3 --> g.

s1 : b,c,e,f :> -g.

d1 : a => b.
d2 : b => c.
d3 : d => e.
d4 : e => f.

graphBuildMode(base).
statementLabellingMode(base).
argumentLabellingMode(grounded).

Caminada 7

f1 --> a.
f2 --> b.
f3 --> c.
f4 --> g.

s1 : d,e,f :> -g.

d1 : a => d.
d2 : b => e.
d3 : c => f.

graphBuildMode(base).
statementLabellingMode(base).
argumentLabellingMode(grounded).

Complete test

r1 : [] => a.
r2 : [] => -a.
r3 : ~(a) => b.
r4 : [] => c.

graphBuildMode(base).
argumentLabellingMode(complete).
statementLabellingMode(base).
