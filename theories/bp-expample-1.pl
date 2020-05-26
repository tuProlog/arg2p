% Simple argumentation (Example 1 and 2)

% r0 : ⇒ p 
% r1 : ⇒ q
% r2 : p ⇒ ¬r 
% r3 : q ⇒ r
% r4 : r ⇒ s 
% r5 : ⇒ ¬s

% r2 > r3

%========================================================================================

r0 : [] => a('Pippo'). 
r1 : [] => q('Pippo').
r2 : a(X) => -r(X).
r3 : q(X)=> r(X).
r4 : r(X) => s(X). 
r5 : [] => -s('Pippo').

sup(r2, r3).

test :-
    convertAllRules,
    buildLabelSets([In, Out, Und]),
    write('\n==============================================> IN '),write('\n'),
    writeList(In),write('\n'),
    write('==============================================> OUT '),write('\n'),
    writeList(Out),write('\n'),
    write('==============================================> UND '),write('\n'),
	writeList(Und),write('\n').