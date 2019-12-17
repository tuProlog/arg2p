rule([rvehi,  [], [vehi] ]).
rule([remer,  [], [emer] ]).
rule([rProh, [ [vehi] ], [obl, [neg, enter]] ]).
rule([rPerm, [ [emer] ], [perm, [enter]] ]).

rule([v, [ [obl, [neg, enter]], [enter] ], [violation] ]).
rule([f, [ [violation] ], [fine] ]).
rule([vPrime, [ ], [neg, violation] ]).
rule([fPrime, [ ], [neg, fine] ]).

rule([s, [ [violation] ], [obl, [stop]] ]).
rule([e, [], [enter] ]).


sup(_, [d, _]).
sup(_, [p, _]).
sup(rPerm, rProh).

sup(v, vPrime).
sup(f, fPrime).


%==============================================

inAsItShouldBe( [
[emer],
[enter],
[neg,fine],
[neg,violation],
[perm,[enter]],
[vehi]
]    ).


outAsItShouldBe( [
[fine],
[obl,[neg,enter]],
[obl,[stop]],
[violation]
] ).

%==============================================

testEmer :-
  (
  go([In, Out, _]),

  inAsItShouldBe( InAsItShouldBe),
  subtract( In, InAsItShouldBe, []),
  subtract( InAsItShouldBe, In, []),
  write( ['==============================================> Test', X, ' OK for statements labelled in.']),write('\n'),

  outAsItShouldBe( OutAsItShouldBe),
  subtract( Out, OutAsItShouldBe, []),
  subtract( OutAsItShouldBe, Out, []),
  write( ['==============================================> Test', X, ' OK for statements labelled und.']),write('\n'),
  write(' ')
   ).
