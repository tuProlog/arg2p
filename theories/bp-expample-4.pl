% Coonflict in BP (Example 7)

% r0 : ⇒ a 
% r1 : a ⇒ b
% r2 : ⇒ ¬a 
% r3 : ¬a ⇒ ¬b

% BP(¬a)
% BP(b)

%========================================================================================

r0 : [] => a('Pippo'). 
r1 : a(X) => b(X).
r2 : [] => -a('Pippo'). 
r3 : -a(X) => -b(X).

bp(-a(X)).
bp(b(X)).

% partialHBP.

demonstration.

test :-
    convertAllRules,
    buildLabelSets([In, Out, Und]),
    write('\n==============================================> IN '),write('\n'),
    writeList(In),write('\n'),
    write('==============================================> OUT '),write('\n'),
    writeList(Out),write('\n'),
    write('==============================================> UND '),write('\n'),
	writeList(Und),write('\n').