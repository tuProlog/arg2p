% Medical malpractice (Example 3)

% r1: ⇒ ¬guidelines 
% r2: ⇒ guidelines
% r3: ¬guidelines ⇒ negligent 
% r4: guidelines ⇒ ¬negligent
% r5: negligent ⇒ liable 
% r6: ¬negligent ⇒ ¬liable

% Example 5
% BP(¬negligent)

% Example 8
% BP(¬negligent) 
% BP(¬guidelines)

%========================================================================================

r1 : [] => -guidelines('Pippo'). 
r2 : [] => guidelines('Pippo').
r3 : -guidelines(X) => negligent(X).
r4 : guidelines(X) => -negligent(X).
r5 : negligent(X) => liable(X). 
r6 : -negligent(X) => -liable(X).

b0 : bp(-negligent(X)).
% b1 : bp(-guidelines(X)).

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