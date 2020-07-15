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
	% TODO: no argument B for neg(φ) such that A < B is IN*
    findUndSubargument(A, UND, RESOLVING, NR, Sub),
    demonstration(Sub, UND, IN_STAR, OUT_STAR, UND_STAR, NR, NewUnd, TempIN, TempOUT, TempUND).
demonstration(A, UND, IN_STAR, OUT_STAR, UND_STAR, RESOLVING, NewUnd, TempIN, OUT_STAR, UND_STAR) :-
	isComplementInBurdenOfProof(A),
	\+ findUndComplargument(UND, A, UND, RESOLVING, _, _),
	\+ findUndSubargument(A, UND, RESOLVING, _, _),
	% TODO: no argument B for neg(φ) such that A < B is IN*, and no A1,...An is OUT*
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
	% TODO: every argument B for neg(φ) is OUT*
    findUndSubargument(A, UND, RESOLVING, NR, Sub),
    demonstration(Sub, UND, IN_STAR, OUT_STAR, UND_STAR, NR, NewUnd, TempIN, TempOUT, TempUND).
demonstration(A, UND, IN_STAR, OUT_STAR, UND_STAR, RESOLVING, NewUnd, TempIN, OUT_STAR, UND_STAR) :-
	\+ isArgumentInBurdenOfProof(A),
	\+ findUndComplargument(UND, A, UND, RESOLVING, _, _),
	\+ findUndSubargument(A, UND, RESOLVING, _, _),
	% TODO: every argument B for neg(φ) is OUT*, and every A1,...An is IN*
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
	% TODO: exists an argument B for neg(φ) such that B(not <)A is not OUT*
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
	% TODO: exist one of A1,...An is not IN*
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
	% TODO: an argument B for neg(φ) such that B(not <)A is IN*
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
	% TODO: one of A1,...An is OUT*
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
    findonesubarg(UND, A, Sub),
    \+ member(Sub, RESOLVING),
    writeDemonstration(['Sub -> ', Sub, ' of ', A]),
    append(RESOLVING, [Sub], NEW_RESOLVING).

findUndComplargument(A, UND, RESOLVING, NEW_RESOLVING, Compl) :-
    findonecompl(UND, A, Compl),
    \+ member(Compl, RESOLVING),
    writeDemonstration(['Compl -> ', Compl, ' of ', A]),
    append(RESOLVING, [Compl], NEW_RESOLVING).

findonesubarg(UND, A, Sub) :-
    support(Sub, A),
    member(Sub, UND).

findonecompl(UND, A, [X, Y, CA]) :-
    complement(A, CA),
    argument([X, Y, CA]),
    member([X, Y, CA], UND).

% IN 1
%complement(A, CA),
%isInBurdenOfProof(CA),
%\+ ( support(_, A), checkSubArguments(A, OUT_STAR) )

% IN 2
%complement(A, CA),
%checkComplementArguments(CA, OUT_STAR),
%checkSubArguments(A, IN_STAR),


% All the arguments with this conclusion are in the Set (If no arguments returns true)
checkComplementArguments(Conclusion, Set) :-
    \+ (argument([A, B, Conclusion]), \+ member([A, B, Conclusion], Set)).
% All the attackers are not in the Set (If no arguments returns true)
checkAttackArguments(A, IN_STAR) :-
    \+ (attack(B, A), member(B, IN_STAR)).
% All the sub-arguments are in the Set (If no sub-arguments returns true)
checkSubArguments(Argument, Set) :-
    \+ (support(Subargument, Argument), \+ member(Subargument, Set)).

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