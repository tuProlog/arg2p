save_execution_environment :- env(_).
save_execution_environment :-
    get_theory(ActualTheory),
    asserta(env(ActualTheory)).

call_module(Module, Query) :-
    save_execution_environment,
	modulesPath(X),
	strings_concat([X, '/', Module, '.pl'], Path),
	text_from_file(Path, ModuleTheory),
	env(MainTheory),
	agent(ModuleTheory, env(MainTheory), Query), !.

strings_concat([], '').
strings_concat([H|T], Y) :-
	strings_concat(T, X),
	atom_concat(H, X, Y).