% ApplLawModule - Italy

applicableLaw(C, ApplicableLaw) :-
    contractDispute,
    call_module(['rome-conv', C], applicableLaw(ApplicableLaw)).
applicableLaw(_, ApplicableLaw) :-
    tortDispute,
    applicableTortLaw(ApplicableLaw).

% TODO: check the correctness of this implementation

applicableTortLaw(ApplicableLaw) :-
    lawOfEvent(ApplicableLaw),
    \+ (lawOfCauseRequestedByDamagedParty(X), X \== ApplicableLaw),
    \+ (lawCommonToParties(Y), Y \== ApplicableLaw).
applicableTortLaw(ApplicableLaw) :-
    lawOfCauseRequestedByDamagedParty(ApplicableLaw),
    \+ (lawCommonToParties(Y), Y \== ApplicableLaw).
applicableTortLaw(ApplicableLaw) :-
    lawCommonToParties(ApplicableLaw).

lawOfEvent(ApplicableLaw) :-
    eventHappenedIn(ApplicableLaw).

lawOfCauseRequestedByDamagedParty(ApplicableLaw) :-
    causeOfDamageHappenedIn(ApplicableLaw),
    damagedPartyRequests(ApplicableLaw).

lawCommonToParties(ApplicableLaw) :-
    allPartiesResideIn(ApplicableLaw).