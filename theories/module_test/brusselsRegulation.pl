% Simple Brussels Refulation rule
hasJurisdiction(test, Country, Court, ClaimId, _):-
    personRole(PersonId, ClaimId, defendant),
    personDomicile(PersonId, Country, Court).

% Brussels Rule that delves into national legislation
hasJurisdiction(Article, Country, Court, ClaimId, Case):-
    personRole(PersonId, ClaimId, defendant),
    personDomicile(PersonId, Country2, _),
    \+(memberState(Country2)),
    memberState(Country),
    call_module([Country, Case], hasJurisdiction(Article, Court, ClaimId)).