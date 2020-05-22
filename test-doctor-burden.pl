f0:  [] => patient('John').
f1a: [] => doctor('Mary').
f2:  [] => expert('Mark').
f3:  [] => expert('Edward').
f4a: [] => say('Mark',harmed('Mary', 'John')).
f5:  [] => say('Edward',followedGuidelines('Mary')).
%
r1: harmed (X,Y), doctor(X) => liable(X).
r2: followedGuidelines(X), doctor(X) => -liable(X).
r3: say(E, harmed(X,Y)), expert(E) => harmed(X, Y).
r4: say(E,followedGuidelines(X)), expert(E) => followedGuidelines(X).
%
b0: bp(-liable(X)).

% bp([[neg, liable('Mary')]]).

%sup(r1, r2).

testDoctor :-
  convertAllRules,
	buildLabelSets([In, Out, Und]),
  write('==============================================> IN '),write('\n'),
  writeList(In),write('\n'),
  write('==============================================> OUT '),write('\n'),
  writeList(Out),write('\n'),
  write('==============================================> UND '),write('\n'),
	writeList(Und),write('\n'), !.


%answerQuery(liable(X), Yes, No, Und).
