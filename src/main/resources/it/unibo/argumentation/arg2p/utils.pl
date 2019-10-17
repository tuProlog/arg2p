% ----------------------------------------------------------------
% utilities.pl
% PIKA-lab
% Year: 2019
% -------------------------------------------------------------------------------


writeList([]).
writeList([X|Others]) :-
	writeln(X),
	writeList(Others).


%-----------------------------------------------------------------

assertaList([]).
assertaList([X|Others]) :-
	asserta(X),
	assertaList(Others).
