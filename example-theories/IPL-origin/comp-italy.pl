% CompModule - Italy

hasCompetence(Court) :-
    coversDefendantsDomicile(Court).
hasCompetence(Court) :-
    coversPlaintiffsDomicile(Court),
    \+ defendantHasDomicileIn(italy).