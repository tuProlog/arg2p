% JurisModule - Italy

hasJurisdiction(italy, _) :-
    defendantHasDomicileIn(italy).
hasJurisdiction(italy, C) :-
    call_module(['brussel-conv', C], hasJurisdiction(italy)).
hasJurisdiction(italy, _) :-
    agreedJurisdiction(italy).
hasJurisdiction(italy, _) :-
    \+ defendantObjectsToJurisdition(italy).