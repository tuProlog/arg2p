r1 : [] :> a.
r2 : a => b.
r3 : b :> c.

r4 : [] :> -c.

graphBuildMode(base).
statementLabellingMode(base).
argumentLabellingMode(grounded).

Caminada 4

s1 : [] :> wr.
s2 : [] :> go.
s3 : b :> -hw.
s4 : m :> hw.

d1 : wr => m.
d1 : go => b.

graphBuildMode(base).
statementLabellingMode(base).
argumentLabellingMode(grounded).

Caminada 5

s1 : [] :> a.
s2 : [] :> d.
s3 : [] :> c.
s4 : b,e :> -c.

d1 : a => b.
d1 : d => e.

graphBuildMode(base).
statementLabellingMode(base).
argumentLabellingMode(grounded).

Caminada 6

s1 : [] :> a.
s2 : [] :> d.
s3 : [] :> g.
s4 : b,c,e,f :> -g.

d1 : a => b.
d2 : b => c.
d3 : d => e.
d4 : e => f.

graphBuildMode(base).
statementLabellingMode(base).
argumentLabellingMode(grounded).

Caminada 7

s1 : [] :> a.
s2 : [] :> b.
s3 : [] :> c.
s4 : [] :> g.
s5 : d,e,f :> -g.

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
