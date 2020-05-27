% ----------------------------------------------------------------
% argumentLabelling.pl
% PIKA-lab
% Year: 2019
% ---------------------------------------------------------------

enablePartialHBP :-
    asserta(partialHBP).

disablePartialHBP :-
    retractall(partialHBP).

writeDemonstration(X) :-
    demonstration,
    write(X).

writeDemonstration(_).

argumentBPLabelling([IN, OUT, UND], [BPIN, BPOUT, BPUND]) :-
    reifyBurdenOfProofs(IN, OUT, UND),
    writeDemonstration('\n=========================================>DEMONSTRATION'),
    ((partialHBP, partialHBPLabelling(UND, IN, OUT, [], BPIN, BPOUT, BPUND));
    hbpComplete(go, IN, OUT, UND, BPIN, BPOUT, BPUND)),
    writeDemonstration('\n=====================================>END DEMONSTRATION').

%==============================================================================
% COMPLETE HBP LABELLING
%==============================================================================

hbpComplete(stop, IN, OUT, UND, IN, OUT, UND).
hbpComplete(G, IN, OUT, UND, BPIN, BPOUT, BPUND) :-
    partialHBPLabelling(UND, IN, OUT, [], BaseIN, BaseOUT, BaseUND),
    completeLabelling(BaseIN, BaseOUT, BaseUND, CompleteIN, CompleteOUT, CompleteUND),
    (IN == CompleteIN, OUT == CompleteOUT, UND == CompleteUND) ->
        hbpComplete(stop, CompleteIN, CompleteOUT, CompleteUND, BPIN, BPOUT, BPUND);
        hbpComplete(G, CompleteIN, CompleteOUT, CompleteUND, BPIN, BPOUT, BPUND).

stopCondition(stop, IN, CompleteIN, OUT, CompleteOUT, UND, CompleteUND).
stopCondition(go, _, _, _, _, _, _).

%==============================================================================
% PARTIAL HBP LABELLING
%==============================================================================

%(a) A is labelled IN iff conc(A) = compl p
%   i) and BP(p) and no subargument A1 that belongs to DirectSub(A) is labelled OUT
%      or
%   ii) every UND-labelled argument B such that conc(B) = p is OUT, and
%       every subargument A1 that belongs to DirectSub(A) is labelled IN;
%(b) A is labelled OUT iff an attacker of A is IN;
%(c) A is labelled UND otherwise.

partialHBPLabelling([], IN_STAR, OUT_STAR, UND_STAR, IN_STAR, OUT_STAR, UND_STAR).
partialHBPLabelling(UND, IN_STAR, OUT_STAR, UND_STAR, ResultIN, ResultOUT, ResultUND) :-
    member(A, UND),
    evaluateHbpArgument(A, UND, IN_STAR, OUT_STAR, UND_STAR, [], NewUnd, TempIN, TempOUT, TempUND),
    partialHBPLabelling(NewUnd, TempIN, TempOUT, TempUND, ResultIN, ResultOUT, ResultUND).

evaluateHbpArgument(A, UND, IN_STAR, OUT_STAR, UND_STAR, RESOLVING, NewUnd, TempIN, TempOUT, TempUND) :-
    findonesubarg(UND, A, Sub),
    \+ member(Sub, RESOLVING),
    append(RESOLVING, [Sub], NR),
    evaluateHbpArgument(Sub, UND, IN_STAR, OUT_STAR, UND_STAR, NR, NewUnd, TempIN, TempOUT, TempUND).
evaluateHbpArgument(A, UND, IN_STAR, OUT_STAR, UND_STAR, _, NewUnd, TempIN, TempOUT, TempUND) :-
    applyHbpRulesIn(A, UND, IN_STAR, OUT_STAR, UND_STAR, NewUnd, TempIN, TempOUT, TempUND).
evaluateHbpArgument(A, UND, IN_STAR, OUT_STAR, UND_STAR, RESOLVING, NewUnd, TempIN, TempOUT, TempUND) :-
    findonecompl(UND, A, Compl),
    \+ member(Compl, RESOLVING),
    append(RESOLVING, [Compl], NR),
    evaluateHbpArgument(Compl, UND, IN_STAR, OUT_STAR, UND_STAR, NR, NewUnd, TempIN, TempOUT, TempUND).
evaluateHbpArgument(A, UND, IN_STAR, OUT_STAR, UND_STAR, _, NewUnd, TempIN, TempOUT, TempUND) :-
    applyHbpRules(A, UND, IN_STAR, OUT_STAR, UND_STAR, NewUnd, TempIN, TempOUT, TempUND).

findonesubarg(UND, A, Sub) :-
    support(Sub, A),
    member(Sub, UND).

findonecompl(UND, A, [X, Y, CA]) :-
    complement(A, CA),
    argument([X, Y, CA]),
    member([X, Y, CA], UND).

/*
    A is labelled IN iff conc(A) = (compl p) and BP(p) and no subargument A1 that belongs
    to DirectSub(A) is labelled OUT

    If my supporting arguments are undecided or true,
    and my argument goes against that in BP,
    then my argument is true.
*/
applyHbpRulesIn(A, UND, IN_STAR, OUT_STAR, UND_STAR, Res_UND, Res_INS, OUT_STAR, UND_STAR) :-
    complement(A, CA),
    isInBurdenOfProof(CA),
    \+ ( support(_, A), checkSubArguments(A, OUT_STAR) ),
    writeDemonstration('\nAdding argument: '), write(A), write(' to IN* (2.a.i)'),
    append(IN_STAR, [A], Res_INS),
    subtract(UND, [A], Res_UND).
applyHbpRulesIn(A, UND, IN_STAR, OUT_STAR, UND_STAR, Res_UND, IN_STAR, Res_OUTS, UND_STAR) :-
    outRule(A, UND, IN_STAR, OUT_STAR, UND_STAR, Res_UND, IN_STAR, Res_OUTS, UND_STAR).
/*
    A is labelled IN iff conc(A) = compl p, every UND-labelled argument B such that conc(B) = p is OUT, and
    every subargument A1 that belongs to DirectSub(A) is labelled IN

    If all the arguments in favor of my complement are false,
    and all my direct sub-arguments are true,
    then my argument is true
*/
applyHbpRules(A, UND, IN_STAR, OUT_STAR, UND_STAR, Res_UND, Res_INS, OUT_STAR, UND_STAR) :-
    complement(A, CA),
    checkComplementArguments(CA, OUT_STAR),
    checkSubArguments(A, IN_STAR),
    writeDemonstration('\nAdding argument: '), write(A), write(' to IN* (2.a.ii)'),
    append(IN_STAR, [A], Res_INS),
    subtract(UND, [A], Res_UND).
applyHbpRules(A, UND, IN_STAR, OUT_STAR, UND_STAR, Res_UND, IN_STAR, Res_OUTS, UND_STAR) :-
    outRule(A, UND, IN_STAR, OUT_STAR, UND_STAR, Res_UND, IN_STAR, Res_OUTS, UND_STAR).
/*
    A is labelled UND iff no other choices are possible
*/
applyHbpRules(A, UND, IN_STAR, OUT_STAR, UND_STAR, Res_UND, IN_STAR, OUT_STAR, Res_UNDS) :-
    writeDemonstration('\nAdding argument: '), write(A), write(' to UND* (2.c)'),
    append(UND_STAR, [A], Res_UNDS),
    subtract(UND, [A], Res_UND).
/*
    A is labelled OUT iff an attacker of A is IN
*/
outRule(A, UND, IN_STAR, OUT_STAR, UND_STAR, Res_UND, IN_STAR, Res_OUTS, UND_STAR) :-
    attack(B, A),
    member(B, IN_STAR), !,
    writeDemonstration('\nAdding argument: '), write(A), write(' to OUT* (2.b)'),
    append(OUT_STAR, [A], Res_OUTS),
    subtract(UND, [A], Res_UND).

%==============================================================================
% COMPLETE LABELLING
%==============================================================================

completeLabelling(IN, OUT, UND, ResultIN, ResultOUT, ResultUND) :-
    findoneIn(IN, OUT, UND, A),
    writeDemonstration('\nAdding argument: '), write(A), write(' to IN* (4.4)'),
    append(IN, [A], NewIN),
    subtract(UND, [A], NewUnd),
    completeLabelling(NewIN, OUT, NewUnd, ResultIN, ResultOUT, ResultUND).
completeLabelling(IN, OUT, UND, ResultIN, ResultOUT, ResultUND) :-
    findoneOut(IN, OUT, UND, A),
    writeDemonstration('\nAdding argument: '), write(A), write(' to OUT* (4.4)'),
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
    Get a conclusion complement ([P] -> [neg, P])
*/
complement([_, _, [neg|A]], A).
complement([_, _, [A]], ['neg',A]).

/*
    Checks Burden of proof membership
*/
isInBurdenOfProof(Concl) :-
    bp(Literals),
    member(Concl, Literals), !.

% All the arguments with this conclusion are in the Set (If no arguments returns true)
checkComplementArguments(Conclusion, Set) :-
    \+ (argument([A, B, Conclusion]), \+ member([A, B, Conclusion], Set)).

% All the sub-arguments are in the Set (If no sub-arguments returns true)
checkSubArguments(Argument, Set) :-
    \+ (support(Subargument, Argument), \+ member(Subargument, Set)).


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
    \+ bp(R),
    asserta(bp(R)),
    computeBp(Conclusions).

computeBp(_).

/*
    Fill the template (first parameter) using predicates belonging
    to the second list (second parameter)
*/
fillTemplate([], _, []).
fillTemplate([H|T], C, [H|R]) :- member(H, C), fillTemplate(T, C, R).

%==============================================================================
% BASE HBP LABELLING
%==============================================================================

%hbpBase(IN, OUT, UND, ResultIN, ResultOUT, ResultUND) :-
%    findall(A, ( member(A, UND), outCondition(A, OUT) ), NewListOUT),
%    append(OUT, NewListOUT, NewOUT),
%    write('\nNEW OUT\n'),
%    writeList(NewListOUT),
%    findall(A, ( member(A, UND), inCondition(A, NewOUT, IN) ), NewListIN),
%    append(IN, NewListIN, NewIN),
%    write('\nNEW IN\n'),
%    writeList(NewListIN),
%    append(NewListIN, NewListOUT, NewLabelledArguments),
%    \+ isEmptyList(NewLabelledArguments),
%    subtract(UND, NewLabelledArguments, NewUnd),
%    hbpBase(NewIN, NewOUT, NewUnd, ResultIN, ResultOUT, ResultUND).
%
%hbpBase(IN, OUT, UND, IN, OUT, UND).
%
%/*
%    A conclusion is in burdenOfProof(Concs) and some A's attackers are not labelled OUT
%*/
%outCondition(A, OUT) :-
%    isInBurdenOfProof(A),
%    attack(B, A),
%    \+ member(B, OUT), !.
%
%/*
%    The conclusionion's complement is in burdenOfProof(Concs) and there are no IN arguments that BP-attack argument A
%    OR
%    The conclusionion is in burdenOfProof(Concs) and all A's attackers are labelled OUT
%*/
%inCondition(A, OUT, IN) :-
%    complement(A, CA),
%    isInBurdenOfProof(CA),
%    \+ ( bpAttack(B, A), write('Bp-attack: '), write(B), write(' -> '), write(A), member(B, IN) ),
%    write(' OK ').
%inCondition(A, OUT, _) :-
%    isInBurdenOfProofArgument(A),
%    \+ ( attack(B, A), \+ (member(B, OUT) )).
%
%/*
%    Find a  bp attacker, if it exists
%    An argument A for f BP-attacks argument B iff A attacks B and -f in BP.
%*/
%bpAttack(A, B) :-
%    attack(A, B),
%    complement(A, CA),
%    isInBurdenOfProof(CA).
%
%/*
%    Checks Burden of proof membership
%*/
%isInBurdenOfProofArgument([_, _, Concl]) :-
%    bp(Literals),
%    member(Concl, Literals), !.