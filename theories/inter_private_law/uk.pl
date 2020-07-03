% substantiveLawMod(uk)

hasToPay(P, X) :-
    failedToPerform(P),
    liquidatedDamage(X).