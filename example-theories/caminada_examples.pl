Carminada 4

s1 : [] :> wr.
s2 : [] :> go.
s3 : b :> -hw.
s4 : m :> hw.

d1 : wr => m.
d1 : go => b.

graphBuildMode(base).
statementLabellingMode(base).
argumentLabellingMode(grounded).

Carminada 5

s1 : [] :> a.
s2 : [] :> d.
s3 : [] :> c.
s4 : b,e :> -c.

d1 : a => b.
d1 : d => e.

graphBuildMode(base).
statementLabellingMode(base).
argumentLabellingMode(grounded).

Carminada 6

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
