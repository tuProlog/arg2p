% BrusselsConventionModule

hasJurisdiction(Country) :-
    defendantHasDomicileIn(Country),
    contractingState(Country).
hasJurisdiction(Country) :-
    contractDispute,
    placePerformance(Country).
hasJurisdiction(Country) :-
    tortDispute,
    placeHarmfulEvent(Country).