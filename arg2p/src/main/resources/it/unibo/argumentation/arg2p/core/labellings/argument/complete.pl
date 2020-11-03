argumentCompleteLabelling([Arguments, Attacks, Supports], [IN, OUT, UND]) :-
    completeLabellingT(Arguments, Attacks, Supports, IN, OUT, UND).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

completeLabellingT(Arguments, Attacks, Supports, ResultIN, ResultOUT, ResultUND) :-
    retractall(compl(_, _, _)),
    grounded(Arguments, Attacks, [], [], Arguments, RAttacks1, IN, OUT, UND),
    findAcceptableSet(UND, RAttacks1, Supports, AcceptableSet),
    append(IN, AcceptableSet, NewIN),
    subtract(UND, AcceptableSet, NewUND),
    grounded(Arguments, RAttacks1, NewIN, OUT, NewUND, _, ResultIN, ResultOUT, ResultUND),
    sort(ResultIN, SortIN),
    sort(ResultOUT, SortOUT),
    sort(ResultUND, SortUND),
    \+ compl(SortIN, SortOUT, SortUND),
    assert(compl(SortIN, SortOUT, SortUND)).

grounded(Arguments, Attacks, IN, OUT, UND, ResultAttacks, ResultIN, ResultOUT, ResultUND) :-
    groundedLabelling(Arguments, Attacks, IN, OUT, UND, ResultAttacks, ResultIN, ResultOUT, ResultUND), !.

/*
    Pick 0, 1, N arguments under these conditions:
        - the resulting set must be conflict-free
*/
findAcceptableSet([], _, _, []).
findAcceptableSet([H|T], Attacks, Supports, [H|T2]) :-
    findAcceptableSet(T, Attacks, Supports, T2),
    \+ (member((_, H, Y), Attacks), member(Y, T2)),
    \+ (member((_, Z, H), Attacks), member(Z, T2)).
findAcceptableSet([_|T], Attacks, Supports, T2) :- findAcceptableSet(T, Attacks, Supports, T2).

%r1 : [] => a.
%r2 : [] => -a.
%r3 : ~(a) => b.
%r4 : [] => c.
%
%graphBuildMode(base).
%argumentLabellingMode(complete_strict_preferences).
%statementLabellingMode(base).
