% Murder case (Example 4)

% r1: ⇒ killed 
% r2: ⇒ intention
% r3: ⇒ threatWithWeapon 
% r4: ⇒ ¬threatWithWeapon
% r5: threatWithWeapon ⇒ selfDefence 
% r6: ¬threatWithWeapon ⇒ ¬selfDefence
% r7: selfDefence ⇒ ¬murder 
% r8: killed, intention ⇒ murder

% r3 > r4

% Example 6
% BP({killed,intention,¬selfDefence})

%========================================================================================

r1: [] => killed('Pippo').
r2: [] => intention('Pippo').
r3: [] => threatWithWeapon('Pippo').
r4: [] => -threatWithWeapon('Pippo').
r5: threatWithWeapon(X) => selfDefence(X).
r6: -threatWithWeapon(X) => -selfDefence(X).
r7: selfDefence(X) => -murder(X).
r8: killed(X), intention(X), -selfDefence(X) => murder(X).

sup(r7, r8).

bp(killed(X), intention(X), -selfDefence(X)).

% partialHBP.

demonstration.
