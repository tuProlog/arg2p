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

% Example 3 - Forse troppo stringente l'implementazione

d1 : dean => professor.
d2 : professor => teach.
d3 : administrator => -teach.

r : dean :> administrator.

be : [] :> dean.
be : [] :> administrator.

sup(d3, d2).