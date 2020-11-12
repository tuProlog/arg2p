% Example 1.1

d1 : dean => prof. 
d2 : prof => teach.
d3 : admin => -teach.

s1 : dean :> admin.

sup(d3, d1).
sup(d2, d3).
sup(d2, d1).

f1 --> dean.
%f2 --> prof.

graphBuildMode(base).
statementLabellingMode(base).
argumentLabellingMode(grounded).
orderingPrinciple(weakest).
orderingComparator(elitist).

% Example 1.2

d1 ~~> a1. 
d2 ~~> a2.
%d ~~> b.

r1 : b, a1 :> -a2.
r2 : b, a2 :> -a1. 
r3 : a1, a2 :> -b.

sup(d2, d1). 

f1 --> b.

graphBuildMode(base).
statementLabellingMode(base).
argumentLabellingMode(grounded).
orderingPrinciple(weakest).
orderingComparator(elitist).
