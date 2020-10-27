argumentGroundedDefeasiblePreferencesLabelling([Arguments, Attacks, _], [IN, OUT, UND]) :-
    labelArgumentsGDP(Arguments, Attacks, [], [], Arguments, IN, OUT, UND), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

labelArgumentsGDP(Arguments, Attacks, IN, OUT, UND, ResultIN, ResultOUT, ResultUND) :-
    member(A, UND), 
    allAttacksOUT(Attacks, A, OUT),
    append(IN, [A], NewIN),
    subtract(UND, [A], NewUND),
    expandPreferenceSet(A, Arguments, Attacks, NewAttacks),
    labelArgumentsGDP(Arguments, NewAttacks, NewIN, OUT, NewUND, ResultIN, ResultOUT, ResultUND).
labelArgumentsGDP(Arguments, Attacks, IN, OUT, UND, ResultIN, ResultOUT, ResultUND) :-
    member(A, UND), 
    oneAttackIN(Attacks, A, IN),
    append(OUT, [A], NewOUT),
    subtract(UND, [A], NewUND),
    labelArgumentsGDP(Arguments, Attacks, IN, NewOUT, NewUND, ResultIN, ResultOUT, ResultUND).
labelArgumentsGDP(_, _, IN, OUT, UND, IN, OUT, UND).

/*
    If an attack exists, it should come from an OUT argument
*/
allAttacksOUT(Attacks, A, OUT) :-
    \+ ( member((B, A), Attacks), \+ ( member(B, OUT))).

/*
    Find an attack, if exists, from an IN argument, then ends
*/
oneAttackIN(Attacks, A, IN) :-
    member((B, A), Attacks),
    member(B, IN), !.

expandPreferenceSet([_, _, [sup(RuleOne, RuleTwo)]], Arguments, Attacks, NewAttacks) :-
    findall(A, computeInvalidAttacks(RuleOne, RuleTwo, Arguments, Attacks, A), IA),
    appendLists(IA, InvalidAttacks),
    subtract(Attacks, InvalidAttacks, NewAttacks).

expandPreferenceSet(_, _, Attacks, Attacks).

computeInvalidAttacks(RuleOne, RuleTwo, Arguments, Attacks, InvalidAttacks) :-
    member([IdOne, RuleOne, COne], Arguments),
    member([IdTwo, RuleTwo, CTwo], Arguments),
    findDerivedArguments([IdTwo, RuleTwo, CTwo], Arguments, Derived),
    findall((A, [IdOne, RuleOne, COne]), member(A, Derived), TempInvalidAttacks),
    append([([IdTwo, RuleTwo, CTwo], [IdOne, RuleOne, COne])], TempInvalidAttacks, InvalidAttacks).

findDerivedArguments([IdTwo, _, _], Arguments, Derived) :-
    findall([Id, T, C], (member([Id, T, C], Arguments), subset(IdTwo, Id), IdTwo \== Id), Derived).

subset([], _).
subset([H|T], List) :- member(H, List), subset(T,List).

% Defeasible preference addition
conflict([sup(X, Y)],  [sup(Y, X)]).

% Se vado in IN controllo la possibile presenza di una indicazione di preferenza
%    sup(r1, r2)
%    se questo è il caso devo invalidare gli attacchi da r2 a r1
%       Arg(topRule r1) > Arg(topRule r2)
%       Arg(topRule r1) > TopArguments(Arg(topRule r2))
%       ->
%       retract : attack(Arg(topRule r2), Arg(topRule r1))
%       retract : foreach x in TopArguments(Arg(topRule r2)) -> attack(x, Arg(topRule r1))