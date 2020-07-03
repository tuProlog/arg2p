modulesPath('C:/Users/peppe_000/Documents/MyProjects/Research/arg2p/theories').

evaluate(Yes, No, Und) :-
  call_module(['module1', 'module-case'], checkJurisdiction(Yes, No, Und)).