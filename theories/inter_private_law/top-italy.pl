% TopModule - Italy

decision(C, Court, Outcome) :-
    call_module(['juris-italy', C], hasJurisdiction(italy, C)),
    call_module(['comp-italy', C], hasCompetence(Court)),
    call_module(['appl-italy', C], applicableLaw(C, SubstantiveLawMod)),
    call_module([SubstantiveLawMod, C], Outcome).
decision(C, _, noJurisdiction) :-
    call_module(['juris-italy', C], \+ hasJurisdiction(italy, C)).
decision(C, Court, noCompetence) :-
    call_module(['comp-italy', C], \+ hasCompetence(Court)).