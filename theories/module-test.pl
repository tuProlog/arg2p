modulesPath('C:/Users/peppe_000/Documents/MyProjects/Research/arg2p/theories').
defendant('Steven').
nationality('Italian').

evaluate(Yes, No, Und) :-
  call_module('module1', checkJurisdiction(Yes, No, Und)).