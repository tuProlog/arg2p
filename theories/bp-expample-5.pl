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

b0 : bp(-a(X)).

% partialHBP.

test :-
    convertAllRules,
    buildLabelSets([In, Out, Und]),
    write('\n==============================================> IN '),write('\n'),
    writeList(In),write('\n'),
    write('==============================================> OUT '),write('\n'),
    writeList(Out),write('\n'),
    write('==============================================> UND '),write('\n'),
	writeList(Und),write('\n').