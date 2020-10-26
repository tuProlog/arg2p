argumentCredulousStrictPreferencesLabelling([Arguments, Attacks, Supports], [IN, OUT, UND]) :-
    labelArgumentsCSP(Arguments, Attacks, Supports, IN, OUT, UND).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

labelArgumentsCSP(Arguments, Attacks, Supports, ResultIN, ResultOUT, ResultUND) :-
    retractall(compl(_, _, _)),
    grounded([], [], Arguments, IN, OUT, UND),
    findAcceptableSet(UND, Attacks, Supports, AcceptableSet),
    write(AcceptableSet),nl,
    append(IN, AcceptableSet, NewIN),
    subtract(UND, AcceptableSet, NewUND),
    grounded(NewIN, OUT, NewUND, ResultIN, ResultOUT, ResultUND),
    sort(ResultIN, SortIN),
    sort(ResultOUT, SortOUT),
    sort(ResultUND, SortUND),
    \+ compl(SortIN, SortOUT, SortUND),
    asserta(compl(SortIN, SortOUT, SortUND)).

grounded(IN, OUT, UND, ResultIN, ResultOUT, ResultUND) :-
    labelArguments(UND, IN, OUT, ResultIN, ResultOUT, ResultUND), !.

findAcceptableSet([], _, _, []).
findAcceptableSet([H|T], Attacks, Supports, [H|T2]) :-
    findAcceptableSet(T, Attacks, Supports, T2),
    \+ (member((H, Y), Attacks), member(Y, T2)),
    \+ (member((Z, H), Attacks), member(Z, T2)).
findAcceptableSet([_|T], Attacks, Supports, T2) :- findAcceptableSet(T, Attacks, Supports, T2).

% Pick 0, 1, N arguments under these conditions:
        % - the resulting set must be conflict-free

% Add these arguments to the IN set
% Apply again grounded semantic

%r1 : [] => a.
%r2 : [] => -a.
%r3 : ~(a) => b.
%
%graphBuildMode(base).
%argumentLabellingMode(credulous_strict_preferences).
%statementLabellingMode(base).
