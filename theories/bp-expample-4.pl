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

b0 : bp(-a(X)).
b1 : bp(b(X)).

test :-
    convertAllRules,
    buildLabelSets([In, Out, Und]),
    write('==============================================> IN '),write('\n'),
    writeList(In),write('\n'),
    write('==============================================> OUT '),write('\n'),
    writeList(Out),write('\n'),
    write('==============================================> UND '),write('\n'),
	writeList(Und),write('\n').