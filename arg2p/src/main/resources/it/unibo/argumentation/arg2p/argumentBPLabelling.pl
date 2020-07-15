% ----------------------------------------------------------------
% argumentLabelling.pl
% PIKA-lab
% Year: 2019
% ---------------------------------------------------------------

enablePartialHBP :-
    asserta(partialHBP).

disablePartialHBP :-
    retractall(partialHBP).

writeDemonstration([]) :-
    demonstration,
    write('\n').
writeDemonstration([X|T]) :-
    demonstration,
    write(X),
    writeDemonstration(T).
writeDemonstration(_).

argumentBPLabelling([IN, OUT, UND], [BPIN, BPOUT, BPUND]) :-
    reifyBurdenOfProofs(IN, OUT, UND),
    writeDemonstration(['=========================================>DEMONSTRATION']),
    ((partialHBP, partialHBPLabelling(UND, IN, OUT, [], BPIN, BPOUT, BPUND));
    hbpComplete(go, IN, OUT, UND, BPIN, BPOUT, BPUND)),
    writeDemonstration(['=====================================>END DEMONSTRATION']).

%==============================================================================
% COMPLETE HBP LABELLING
%==============================================================================

hbpComplete(stop, IN, OUT, UND, IN, OUT, UND).
hbpComplete(_, IN, OUT, UND, BPIN, BPOUT, BPUND) :-
    writeDemonstration(['======================================================>']),
    partialHBPLabelling(UND, IN, OUT, [], BaseIN, BaseOUT, BaseUND),
    completeLabelling(BaseIN, BaseOUT, BaseUND, CompleteIN, CompleteOUT, CompleteUND),
    stopCondition(FLAG, IN, CompleteIN, OUT, CompleteOUT, UND, CompleteUND),
    hbpComplete(FLAG, CompleteIN, CompleteOUT, CompleteUND, BPIN, BPOUT, BPUND).

stopCondition(stop, IN, IN, OUT, OUT, UND, UND).
stopCondition(go, _, _, _, _, _, _).

%==============================================================================
% PARTIAL HBP LABELLING
%==============================================================================

partialHBPLabelling([], IN_STAR, OUT_STAR, UND_STAR, IN_STAR, OUT_STAR, UND_STAR).
partialHBPLabelling(UND, IN_STAR, OUT_STAR, UND_STAR, ResultIN, ResultOUT, ResultUND) :-
    member(A, UND),
    writeDemonstration(['Evaluating ', A]),
    demonstration(A, UND, IN_STAR, OUT_STAR, UND_STAR, [], NewUnd, TempIN, TempOUT, TempUND),
    partialHBPLabelling(NewUnd, TempIN, TempOUT, TempUND, ResultIN, ResultOUT, ResultUND).

/*
    (a.i) BP(neg(φ)), and no argument B for neg(φ) such that A < B is IN*, and no A1,...An is OUT*
*/
demonstration(A, UND, IN_STAR, OUT_STAR, UND_STAR, RESOLVING, NewUnd, TempIN, TempOUT, TempUND) :-
    isComplementInBurdenOfProof(A),
	findUndComplargument(A, UND, RESOLVING, NR, Compl),
    demonstration(Compl, UND, IN_STAR, OUT_STAR, UND_STAR, NR, NewUnd, TempIN, TempOUT, TempUND).
demonstration(A, UND, IN_STAR, OUT_STAR, UND_STAR, RESOLVING, NewUnd, TempIN, TempOUT, TempUND) :-
	isComplementInBurdenOfProof(A),
	\+ findUndComplargument(UND, A, UND, RESOLVING, _, _),
	noSuperiorComplementInSet(A, IN_STAR),
    findUndSubargument(A, UND, RESOLVING, NR, Sub),
    demonstration(Sub, UND, IN_STAR, OUT_STAR, UND_STAR, NR, NewUnd, TempIN, TempOUT, TempUND).
demonstration(A, UND, IN_STAR, OUT_STAR, UND_STAR, RESOLVING, NewUnd, TempIN, OUT_STAR, UND_STAR) :-
	isComplementInBurdenOfProof(A),
	\+ findUndComplargument(UND, A, UND, RESOLVING, _, _),
	\+ findUndSubargument(A, UND, RESOLVING, _, _),
	noSuperiorComplementInSet(A, IN_STAR),
	noSubArgumentInSet(A, OUT_STAR),
	writeDemonstration(['Adding argument: ', A, ' to IN* (2.a.i)']),
    append(IN_STAR, [A], TempIN),
    subtract(UND, [A], NewUnd).

/*
    (a.ii) not BP(φ) and every argument B for neg(φ) is OUT*, and every A1,...An is IN*
*/
demonstration(A, UND, IN_STAR, OUT_STAR, UND_STAR, RESOLVING, NewUnd, TempIN, TempOUT, TempUND) :-
    \+ isArgumentInBurdenOfProof(A),
	findUndComplargument(A, UND, RESOLVING, NR, Compl),
    demonstration(Compl, UND, IN_STAR, OUT_STAR, UND_STAR, NR, NewUnd, TempIN, TempOUT, TempUND).
demonstration(A, UND, IN_STAR, OUT_STAR, UND_STAR, RESOLVING, NewUnd, TempIN, TempOUT, TempUND) :-
	\+ isArgumentInBurdenOfProof(A),
	\+ findUndComplargument(UND, A, UND, RESOLVING, _, _),
	allComplementInSet(A, OUT_STAR),
    findUndSubargument(A, UND, RESOLVING, NR, Sub),
    demonstration(Sub, UND, IN_STAR, OUT_STAR, UND_STAR, NR, NewUnd, TempIN, TempOUT, TempUND).
demonstration(A, UND, IN_STAR, OUT_STAR, UND_STAR, RESOLVING, NewUnd, TempIN, OUT_STAR, UND_STAR) :-
	\+ isArgumentInBurdenOfProof(A),
	\+ findUndComplargument(UND, A, UND, RESOLVING, _, _),
	\+ findUndSubargument(A, UND, RESOLVING, _, _),
	allComplementInSet(A, OUT_STAR),
	allSubArgumentInSet(A, IN_STAR),
	writeDemonstration(['Adding argument: ', A, ' to IN* (2.a.ii)']),
    append(IN_STAR, [A], TempIN),
    subtract(UND, [A], NewUnd).

/*
    (b.i.1) BP(φ) and exists an argument B for neg(φ) such that B(not <)A is not OUT*
*/
demonstration(A, UND, IN_STAR, OUT_STAR, UND_STAR, RESOLVING, NewUnd, TempIN, TempOUT, TempUND) :-
	isArgumentInBurdenOfProof(A),
	findUndComplargument(A, UND, RESOLVING, NR, Compl),
    demonstration(Compl, UND, IN_STAR, OUT_STAR, UND_STAR, NR, NewUnd, TempIN, TempOUT, TempUND).
demonstration(A, UND, IN_STAR, OUT_STAR, UND_STAR, RESOLVING, NewUnd, IN_STAR, TempOUT, UND_STAR) :-
	isArgumentInBurdenOfProof(A),
	\+ findUndComplargument(UND, A, UND, RESOLVING, _, _),
	oneOutSuperiorOrEqualComplementFromSet(A, OUT_STAR),
    writeDemonstration(['Adding argument: ', A, ' to OUT* (2.b.i.1)']),
    append(OUT_STAR, [A], TempOUT),
    subtract(UND, [A], NewUnd).

/*
    (b.i.2) BP(φ) and exist one of A1,...An is not IN*
*/
demonstration(A, UND, IN_STAR, OUT_STAR, UND_STAR, RESOLVING, NewUnd, TempIN, TempOUT, TempUND) :-
	isArgumentInBurdenOfProof(A),
	findUndSubargument(A, UND, RESOLVING, NR, Sub),
    demonstration(Sub, UND, IN_STAR, OUT_STAR, UND_STAR, NR, NewUnd, TempIN, TempOUT, TempUND).
demonstration(A, UND, IN_STAR, OUT_STAR, UND_STAR, RESOLVING, NewUnd, IN_STAR, TempOUT, UND_STAR) :-
	isArgumentInBurdenOfProof(A),
	\+ findUndSubargument(UND, A, UND, RESOLVING, _, _),
	oneOutSubArgumentFromSet(A, IN_STAR),
    writeDemonstration(['Adding argument: ', A, ' to OUT* (2.b.i.2)']),
    append(OUT_STAR, [A], TempOUT),
    subtract(UND, [A], NewUnd).

/*
    (b.ii.1) not BP(φ) and an argument B for neg(φ) such that B(not <)A is IN*
*/
demonstration(A, UND, IN_STAR, OUT_STAR, UND_STAR, RESOLVING, NewUnd, TempIN, TempOUT, TempUND) :-
	\+ isArgumentInBurdenOfProof(A),
	findUndComplargument(A, UND, RESOLVING, NR, Compl),
    demonstration(Compl, UND, IN_STAR, OUT_STAR, UND_STAR, NR, NewUnd, TempIN, TempOUT, TempUND).
demonstration(A, UND, IN_STAR, OUT_STAR, UND_STAR, RESOLVING, NewUnd, IN_STAR, TempOUT, UND_STAR) :-
	\+ isArgumentInBurdenOfProof(A),
	\+ findUndComplargument(UND, A, UND, RESOLVING, _, _),
	oneInSuperiorOrEqualComplementFromSet(A, IN_STAR),
    writeDemonstration(['Adding argument: ', A, ' to OUT* (2.b.ii.1)']),
    append(OUT_STAR, [A], TempOUT),
    subtract(UND, [A], NewUnd).

/*
    (b.ii.2) not BP(φ) and one of A1,...An is OUT*
*/
demonstration(A, UND, IN_STAR, OUT_STAR, UND_STAR, RESOLVING, NewUnd, TempIN, TempOUT, TempUND) :-
	\+ isArgumentInBurdenOfProof(A),
	findUndSubargument(A, UND, RESOLVING, NR, Sub),
    demonstration(Sub, UND, IN_STAR, OUT_STAR, UND_STAR, NR, NewUnd, TempIN, TempOUT, TempUND).
demonstration(A, UND, IN_STAR, OUT_STAR, UND_STAR, RESOLVING, NewUnd, IN_STAR, TempOUT, UND_STAR) :-
	\+ isArgumentInBurdenOfProof(A),
	\+ findUndSubargument(UND, A, UND, RESOLVING, _, _),
	oneInSubArgumentFromSet(A, OUT_STAR),
    writeDemonstration(['Adding argument: ', A, ' to OUT* (2.b.ii.2)']),
    append(OUT_STAR, [A], TempOUT),
    subtract(UND, [A], NewUnd).

/*
    (c) A is labelled UND* otherwise.
*/
demonstration(A, UND, IN_STAR, OUT_STAR, UND_STAR, _, NewUnd, IN_STAR, OUT_STAR, TempUND) :-
	writeDemonstration(['Adding argument: ', A, ' to UND* (2.c)']),
    append(UND_STAR, [A], TempUND),
    subtract(UND, [A], NewUnd).

/*
    Load dependencies
*/
findUndSubargument(A, UND, RESOLVING, NEW_RESOLVING, Sub) :-
    support(Sub, A),
    member(Sub, UND),
%    writeDemonstration(['Sub -> ', Sub, ' of ', A]),
    \+ member(Sub, RESOLVING),
    append(RESOLVING, [Sub], NEW_RESOLVING).

findUndComplargument(A, UND, RESOLVING, NEW_RESOLVING, Compl) :-
    complement(A, CA),
    argument([X, Y, CA]),
    Compl = [X, Y, CA],
    member(Compl, UND),
%    writeDemonstration(['Compl -> ', Compl, ' of ', A]),
    \+ member(Compl, RESOLVING),
    append(RESOLVING, [Compl], NEW_RESOLVING).

/*
    Conditions
*/

noSuperiorComplementInSet(Argument, Set) :-
    superiorComplArguments(Argument, LIST),
    noInWithEmptyCheck(LIST, Set).

noSubArgumentInSet(Argument, Set) :-
    allDirectsSubArguments(Argument, LIST),
    noInWithEmptyCheck(LIST, Set).

allComplementInSet(Argument, Set) :-
    allComplArguments(Argument, LIST),
    allInWithEmptyCheck(LIST, Set).

allSubArgumentInSet(Argument, Set) :-
    allDirectsSubArguments(Argument, LIST),
    allInWithEmptyCheck(LIST, Set).

oneOutSuperiorOrEqualComplementFromSet(Argument, Set) :-
    superiorOrEqualComplArguments(Argument, LIST),
    oneOutWithEmptyCheck(LIST, Set).

oneOutSubArgumentFromSet(Argument, Set) :-
    allDirectsSubArguments(Argument, LIST),
    oneOut(LIST, Set).

oneInSuperiorOrEqualComplementFromSet(Argument, Set) :-
    superiorOrEqualComplArguments(Argument, LIST),
    oneInWithEmptyCheck(LIST, Set).

oneInSubArgumentFromSet(Argument, Set) :-
    allDirectsSubArguments(Argument, LIST),
    oneIn(LIST, Set).

/*
    Support
*/

allDirectsSubArguments(Argument, LIST) :-
    findall(Sub, support(Sub, Argument), LIST).

allComplArguments(Argument, LIST) :-
    complement(Argument, CA),
    findall([A, B, CA], argument([A, B, CA]), LIST).

superiorComplArguments(Argument, LIST) :-
    complement(Argument, CA),
    findall([A, B, CA], (argument([A, B, CA]), superiorArgument([A, B, CA], Argument)), LIST).

superiorOrEqualComplArguments(Argument, LIST) :-
    complement(Argument, CA),
    findall([A, B, CA], (argument([A, B, CA]), \+ superiorArgument(Argument, [A, B, CA])), LIST).


noInWithEmptyCheck([], _).
noInWithEmptyCheck(List, Target) :- noIn(List, Target).
noIn(List, Target) :-
    member(X, List),
    \+ member(X, Target).

allInWithEmptyCheck([], _).
allInWithEmptyCheck(List, Target) :- allIn(List, Target).
allIn(List, Target) :-
    member(X, List),
    \+ (member(X, List), \+ member(X, Target)).

oneInWithEmptyCheck([], _).
oneInWithEmptyCheck(List, Target) :- oneIn(List, Target).
oneIn(List, Target) :-
    member(X, List),
    member(X, Target).

oneOutWithEmptyCheck([], _).
oneOutWithEmptyCheck(List, Target) :- oneOut(List, Target).
oneOut(List, Target) :-
    member(X, List),
    \+ member(X, Target).

%==============================================================================
% COMPLETE LABELLING
%==============================================================================

completeLabelling(IN, OUT, UND, ResultIN, ResultOUT, ResultUND) :-
    findoneIn(IN, OUT, UND, A),
    writeDemonstration(['Adding argument: ', A, ' to IN* (4.4)']),
    append(IN, [A], NewIN),
    subtract(UND, [A], NewUnd),
    completeLabelling(NewIN, OUT, NewUnd, ResultIN, ResultOUT, ResultUND).
completeLabelling(IN, OUT, UND, ResultIN, ResultOUT, ResultUND) :-
    findoneOut(IN, OUT, UND, A),
    writeDemonstration(['Adding argument: ', A, ' to OUT* (4.4)']),
    append(OUT, [A], NewOUT),
    subtract(UND, [A], NewUnd),
    completeLabelling(IN, NewOUT, NewUnd, ResultIN, ResultOUT, ResultUND).
completeLabelling(IN, OUT, UND, IN, OUT, UND).

findoneIn(IN, OUT, UND, A):-
    member(A, UND),
    completeIn(A, IN, OUT).

findoneOut(IN, OUT, UND, A):-
    member(A, UND),
    completeOut(A, IN, OUT).

completeIn(A, _, OUT) :- checkOutAttackers(A, OUT).
/*
    If an attack exists, it should come from an OUT argument
*/
checkOutAttackers(A, OUT) :-
    \+ ( attack(B, A), \+ ( member(B, OUT)) ).


completeOut(A, IN, _) :- checkInAttacker(A, IN).
completeOut(A, IN, _) :- checkInAttecked(A, IN).
/*
    Find an attack, if exists, from an IN argument, then ends
*/
checkInAttacker(A, IN) :-
    attack(B, A),
    member(B, IN), !.

/*
    If A attacks an IN argument, then A is OUT
*/
checkInAttecked(A, IN) :-
    attack(A, B),
    member(B, IN), !.

%==============================================================================
% HBP LABELLING UTILITIES
%==============================================================================

/*
    Checks Burden of proof membership
*/
isInBurdenOfProof(Concl) :-
    reifiedBp(Literals),
    member(Concl, Literals), !.

isComplementInBurdenOfProof(A) :-
    complement(A, Compl),
    isInBurdenOfProof(Compl).

isArgumentInBurdenOfProof([_, _, Concl]) :-
    isInBurdenOfProof(Concl).

/*
    Get a conclusion complement ([P] -> [neg, P])
*/
complement([_, _, [neg|A]], A).
complement([_, _, [A]], ['neg',A]).

%==============================================================================
% BURDEN OF PROOF REIFICATION
%==============================================================================

reifyBurdenOfProofs(IN, OUT, UND) :-
    extractConclusions(IN, OUT, UND, Conclusions),
    computeBp(Conclusions).

extractConclusions(IN, OUT, UND, SL) :-
    findall(Conc, member([_, _, Conc], IN), In),
    findall(Conc, member([_, _, Conc], OUT), Out),
    findall(Conc, member([_, _, Conc], UND), Und),
    appendLists([In, Out, Und], L),
    sort(L, SL).

computeBp(Conclusions) :-
    abstractBp(AbstractBp),
    fillTemplate(AbstractBp, Conclusions, R),
    \+ reifiedBp(R),
    asserta(reifiedBp(R)),
    computeBp(Conclusions).

computeBp(_).

/*
    Fill the template (first parameter) using predicates belonging
    to the second list (second parameter)
*/
fillTemplate([], _, []).
fillTemplate([H|T], C, [H|R]) :- member(H, C), fillTemplate(T, C, R).