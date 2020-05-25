% ----------------------------------------------------------------
% argumentLabelling.pl
% PIKA-lab
% Year: 2019
% ---------------------------------------------------------------

argumentBPLabelling([IN, OUT, UND], [BPIN, BPOUT, BPUND]) :-
    reifyBurdenOfProofs(IN, OUT, UND),
    (partialHBP, hbpPartial(IN, OUT, UND, BPIN, BPOUT, BPUND));
    hbpComplete(IN, OUT, UND, BPIN, BPOUT, BPUND).

%==============================================================================
% COMPLETE HBP LABELLING
%==============================================================================

hbpComplete(IN, OUT, UND, BPIN, BPOUT, BPUND) :-
    hbpPartial(IN, OUT, UND, BaseIN, BaseOUT, BaseUND),
    completeLabelling(BaseIN, BaseOUT, BaseUND, CompleteIN, CompleteOUT, CompleteUND),
    \+ (IN == CompleteIN, OUT == CompleteOUT, UND == CompleteUND),
    hbpComplete(CompleteIN, CompleteOUT, CompleteUND, BPIN, BPOUT, BPUND).

hbpComplete(IN, OUT, UND, IN, OUT, UND).

%==============================================================================
% IMPROVED PARTIAL HBP LABELLING
%==============================================================================

%(a) A is labelled IN iff conc(A) = compl p
%   i) and BP(p) and no subargument A1 that belongs to DirectSub(A) is labelled OUT
%      or
%   ii) every UND-labelled argument B such that conc(B) = p is OUT, and
%       every subargument A1 that belongs to DirectSub(A) is labelled IN;
%(b) A is labelled OUT iff an attacker of A is IN;
%(c) A is labelled UND otherwise.

hbpPartial(IN, OUT, UND, ResultIN, ResultOUT, ResultUND) :-
    findall(A, ( member(A, UND), partialInCondition(A, IN, OUT) ), NewListIN),
    append(IN, NewListIN, NewIN),
    findall(A, ( member(A, UND), parialOutCondition(A, NewListIN, OUT) ), NewListOUT),
    append(OUT, NewListOUT, NewOUT),
    append(NewListIN, NewListOUT, NewLabelledArguments),
    \+ isEmptyList(NewLabelledArguments),
    subtract(UND, NewLabelledArguments, NewUnd),
    hbpPartial(NewIN, NewOUT, NewUnd, ResultIN, ResultOUT, ResultUND).

hbpPartial(IN, OUT, UND, IN, OUT, UND).

/*
    A is labelled OUT iff an attacker of A is IN
*/
parialOutCondition(A, IN, _) :-
    attack(B, A),
    member(B, IN), !.
/*
    A is labelled IN iff conc(A) = (compl p) and BP(p) and no subargument A1 that belongs
    to DirectSub(A) is labelled OUT

    Se gli argomenti diretti a mio sostegno sono indecisi o veri, e il mio argomento va contro quello in BP, allora il
    mio argomento è vero
*/
partialInCondition(A, _, OUT) :-
    complement(A, CA),
    isInBurdenOfProofStatement(CA),
    \+ checkSubArguments(A, OUT).
/*
    A is labelled IN iff conc(A) = compl p, every UND-labelled argument B such that conc(B) = p is OUT, and
    every subargument A1 that belongs to DirectSub(A) is labelled IN

    Se tutti gli argomenti a favore del mio complemento sono falsi, e tutti i miei sotto argomenti diretti sono
    veri, allora sono vero
*/
partialInCondition(A, IN, OUT) :-
    complement(A, CA),
    checkComplementArguments(CA, OUT),
    checkSubArguments(A, IN).

% Tutti gli argomenti con questa conclusione sono nel Set
checkComplementArguments(Conclusion, Set) :-
    \+ (argument([A, B, Conclusion]), \+ member([A, B, Conclusion], Set)).

% Tutti i sotto argomenti diretti sono nel Set
checkSubArguments(Argument, Set) :-
    \+ (support(Subargument, Argument), \+ member(Subargument, Set)).

%==============================================================================
% BASE HBP LABELLING
%==============================================================================

hbpBase(IN, OUT, UND, ResultIN, ResultOUT, ResultUND) :-
    findall(A, ( member(A, UND), outCondition(A, OUT) ), NewListOUT),
    append(OUT, NewListOUT, NewOUT),
    write('\nNEW OUT\n'),
    writeList(NewListOUT),
    findall(A, ( member(A, UND), inCondition(A, NewOUT, IN) ), NewListIN),
    append(IN, NewListIN, NewIN),
    write('\nNEW IN\n'),
    writeList(NewListIN),
    append(NewListIN, NewListOUT, NewLabelledArguments),
    \+ isEmptyList(NewLabelledArguments),
    subtract(UND, NewLabelledArguments, NewUnd),
    hbpBase(NewIN, NewOUT, NewUnd, ResultIN, ResultOUT, ResultUND).

hbpBase(IN, OUT, UND, IN, OUT, UND).

/*
    A conclusion is in burdenOfProof(Concs) and some A's attackers are not labelled OUT
*/
outCondition(A, OUT) :-
    isInBurdenOfProof(A),
    attack(B, A),
    \+ member(B, OUT), !.

/*
    The conclusionion's complement is in burdenOfProof(Concs) and there are no IN arguments that BP-attack argument A
    OR
    The conclusionion is in burdenOfProof(Concs) and all A's attackers are labelled OUT
*/
inCondition(A, OUT, IN) :-
    complement(A, CA),
    isInBurdenOfProofStatement(CA),
    \+ ( bpAttack(B, A), write('Bp-attack: '), write(B), write(' -> '), write(A), member(B, IN) ),
    write(' OK ').
inCondition(A, OUT, _) :-
    isInBurdenOfProof(A),
    \+ ( attack(B, A), \+ (member(B, OUT) )).

%==============================================================================
% HBP LABELLING UTILITIES
%==============================================================================

/*
    Get a conclusion complement ([P] -> [neg, P])
*/
complement([_, _, [neg|A]], A).
complement([_, _, [A]], ['neg',A]).

/*
    Find a  bp attacker, if it exists
    An argument A for f BP-attacks argument B iff A attacks B and -f in BP.
*/
bpAttack(A, B) :-
    attack(A, B),
    complement(A, CA),
    isInBurdenOfProofStatement(CA).

/*
    Checks Burden of proof membership
*/
isInBurdenOfProof([_, _, Concl]) :-
    bp(Literals),
    member(Concl, Literals), !.

/*
    Checks Burden of proof membership
*/
isInBurdenOfProofStatement(Concl) :-
    bp(Literals),
    member(Concl, Literals), !.

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
% COMPLETE LABELLING
%==============================================================================

completeLabelling(IN, OUT, UND, ResultIN, ResultOUT, ResultUND) :-
   findall(A, ( member(A, UND), completeIn(A, IN, OUT) ), NewListIN),
   append(IN, NewListIN, NewIN),
   findall(A, ( member(A, UND), completeOut(A, NewIN, OUT) ), NewListOUT),
   append(OUT, NewListOUT, NewOUT),

   append(NewListIN, NewListOUT, NewLabelledArguments),
   \+ isEmptyList(NewLabelledArguments),

   subtract(UND, NewLabelledArguments, UndPlus1),
   completeLabelling(NewIN, NewOUT, UndPlus1, ResultIN, ResultOUT, ResultUND).

completeLabelling(IN, OUT, UND, IN, OUT, UND).


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
