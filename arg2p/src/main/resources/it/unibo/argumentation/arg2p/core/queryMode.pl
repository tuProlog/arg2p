computeStatementAcceptance(Goal, YesResult, NoResult, UndResult) :-
    computeGlobalAcceptance([STATIN, STATOUT, STATUND], [_, _, _]),
    findall(Goal, answerSingleQuery(Goal, STATIN), YesResult),
    findall(Goal, answerSingleQuery(Goal, STATOUT), NoResult),
    findall(Goal, answerSingleQuery(Goal, STATUND), UndResult).

answerSingleQuery(Goal, Set) :-
    check_modifiers_in_list([Goal], [X]),
    member(X, Set).
