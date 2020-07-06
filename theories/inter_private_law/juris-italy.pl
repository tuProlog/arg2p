% JurisModule - Italy

hasJurisdiction(italy, _) :-
    defendantHasDomicileIn(italy).
hasJurisdiction(italy, Case) :-
    call_module(['brussel-conv', Case], hasJurisdiction(italy)).
hasJurisdiction(italy, _) :-
    agreedJurisdiction(italy).
hasJurisdiction(italy, _) :-
    \+ defendantObjectsToJurisdition(italy).