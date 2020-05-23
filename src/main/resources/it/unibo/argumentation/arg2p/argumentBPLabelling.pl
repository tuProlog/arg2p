% ----------------------------------------------------------------
% argumentLabelling.pl
% PIKA-lab
% Year: 2019
% ---------------------------------------------------------------

argumentBPLabelling([IN, OUT, UND], [BPIN, BPOUT, BPUND]) :-
    reifyBurdenOfProofs(IN, OUT, UND),
    (partialHBP, hbpBase(IN, OUT, UND, BPIN, BPOUT, BPUND));
    hbpComplete(IN, OUT, UND, BPIN, BPOUT, BPUND).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hbpComplete(IN, OUT, UND, BPIN, BPOUT, BPUND) :-
    hbpBase(IN, OUT, UND, BaseIN, BaseOUT, BaseUND),
    labelArguments(BaseUND, BaseIN, BaseOUT, CompleteIN, CompleteOUT, CompleteUND),
    \+ (IN == CompleteIN, OUT == CompleteOUT, UND == CompleteUND),
    hbpComplete(CompleteIN, CompleteOUT, CompleteUND, BPIN, BPOUT, BPUND).

hbpComplete(IN, OUT, UND, IN, OUT, UND).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hbpBase(IN, OUT, UND, ResultIN, ResultOUT, ResultUND) :-
    findall(A, ( member(A, UND), outCondition(A, OUT) ), NewListOUT),
    append(OUT, NewListOUT, NewOUT),
    findall(A, ( member(A, UND), inCondition(A, NewOUT, IN) ), NewListIN),
    append(IN, NewListIN, NewIN),
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
    (complement(A, CA), isInBurdenOfProofStatement(CA), \+ ( bpAttack(B, A), member(B, IN) ));
    (isInBurdenOfProof(A), \+ ( attack(B, A), \+ (member(B, OUT) ))).

/*
    Get a conclusion complement ([P] -> [neg, P])
*/
complement([_, _, [neg|A]], A).
complement([_, _, [A]], ['neg',A]).

/*
    Find a  bp attacker, if it exists
*/
bpAttack(B, A) :-
    attack(B, A),
    isInBurdenOfProof(B).

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

%====================================================================================

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
    Fill the template (first parameter) using predicates belonging to the second list (second parameter)
*/
fillTemplate([], _, []).
fillTemplate([H|T1], [H|T2], [H|R]) :- fillTemplate(T1, T2, R).
fillTemplate([H1|T1], [H2|T2], R) :- H1 \= H2, fillTemplate([H1|T1], T2, R).