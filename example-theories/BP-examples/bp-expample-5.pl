% Circular argumentation (Example 9)

% r0 : ¬c ⇒ p 
% r1 : p ⇒ c
% r2 : ⇒ ¬p 
% r3 : ⇒ ¬c

% BP(¬p)

%========================================================================================

r0 : -c(X) => a(X).
r1 : a(X) => c(X).
r2 : [] => -a('Pippo').
r3 : [] => -c('Pippo').

bp(-a(X)).

% partialHBP.

demonstration.
