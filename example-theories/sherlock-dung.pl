% Sherlock - Dung

r1 : inno(p1), inno(s) :> -inno(p2).

be : [] :> inno(s).

d1 : [] => inno(p1). 
d2 : [] => inno(p2). 
d : [] => inno(s).

sup(d2, d1).

graphBuildMode(base).
statementLabellingMode(base).
argumentLabellingMode(complete).

% Example 3

d1: dean => professor.
d2: professor => teach.
d3: administrator => -teach.

r: dean :> administrator.

d --> dean.
p --> professor.

sup(d3, d2).

graphBuildMode(base).
statementLabellingMode(base).
argumentLabellingMode(grounded).
orderingPrinciple(last).
orderingComparator(democrat).


% Sherlock cont

r1 : inno(p1), inno(s) :> -inno(p2).
r4 : beneficiary(p1) :> have_motive(p1).
r5 : beneficiary(p2) :> have_motive(p2).

f1 --> inno(s).
f2 --> beneficiary(p1).

d : [] => inno(s).
d1 : [] => inno(p1). 
d2 : [] => inno(p2).
d3 : [] => -have_motive(p1).
d4 : [] => -have_motive(p2).

p1 : have_motive(p1), -have_motive(p2) :> sup(d2, d1).
p2 : -have_motive(p1), have_motive(p2) :> sup(d1, d2).

graphBuildMode(pgraph).
statementLabellingMode(base).
argumentLabellingMode(grounded).
orderingPrinciple(last).
orderingComparator(normal).
