checkJurisdiction(Yes, No, Und) :-
    nationality('Italian'),
    call_module('module2', checkLabelling(Yes, No, Und)).
