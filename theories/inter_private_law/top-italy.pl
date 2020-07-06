% TopModule - Italy

decision(Case, Court, Outcome) :-
    call_module(['juris-italy', Case], hasJurisdiction(italy, Case)),
    call_module(['comp-italy', Case], hasCompetence(Court)),
    call_module(['appl-italy', Case], applicableLaw(Case, SubstantiveLawMod)),
    call_module([SubstantiveLawMod, Case], Outcome).
decision(Case, _, noJurisdiction) :-
    call_module(['juris-italy', Case], \+ hasJurisdiction(italy, Case)).
decision(Case, Court, noCompetence) :-
    call_module(['comp-italy', Case], \+ hasCompetence(Court)).