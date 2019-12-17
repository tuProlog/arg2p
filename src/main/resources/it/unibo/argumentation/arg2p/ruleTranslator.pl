% ----------------------------------------------------------------
% ruleTranslator.pl
% PIKA-lab
% Year: 2019
% -------------------------------------------------------------------------------

% rule_name : o(-what_is_mandatory_to_avoid), o(what_is_mandatory), p(what_is_permitted), p(-what_is_permitted), what_is_true, -what_is_true => effect.
% are converted into lists expressing rules
% rule([v, [ [obl, [neg, enter]], [enter] ], [violation] ]).
% rule([rPerm, [ [emer] ], [perm, [enter]] ]).


:- op(1199, xfx, '=>').
:- op(1001, xfx, ':').


in(A, A) :- nonvar(A), A \= (_ , _).
in(A, (A, _)).
in(A, (_ , Cs)) :- in(A, Cs).

convertRule :- (RuleName : Preconditions => Effects), %write('Preconditions '),write(Preconditions), nl,
							%findall(X, in(X, Preconditions), Lprecond), findall(Y, in(Y, Effects), Leffects),
							tuple_to_list(Preconditions, Lprecond),  tuple_to_list(Effects, Leffects),
							write('Leffects '),write(Leffects), nl,
							check_negation(Lprecond, LprecondChecked),
							%write('Leffects '), write(Leffects), nl,
							check_negation_effects(Leffects, LeffectsChecked),
							%write('LeffectsChecked '), write(LeffectsChecked), nl,
							List = [RuleName, LprecondChecked, LeffectsChecked],
							%write(' Assert '), write(List), nl,
							assert(rule(List)).

tuple_to_list((A,B),L) :- tuple_to_list(A, La), tuple_to_list(B, Lb), append(La, Lb,L).
tuple_to_list(A,[A]) :- nonvar(A), A \= (_ , _).

check_negation([], []).
check_negation([H|T], L) :- H == [], L=[].
check_negation([H|T], L) :- H \== [], check_head_negation(H, ListHead),
														check_negation(T,Ltail), append(ListHead, Ltail, L).

check_head_negation([], []).
check_head_negation(H, List) :-	functor(H, Name, _), %write('functor name '), write(Name), nl,
																(Name = '-') -> H =.. L, replace('-', 'neg', L, Lf), List = [Lf] ; %List=[H],
																(functor(H, Name, Arity), Name = 'o') -> (arg(1, H, Arg), check_head_negation(Arg, Lobl), List =[['obl'|Lobl]]) ;
																(functor(H, Name, Arity), Name = 'p') -> (arg(1, H, Arg), check_head_negation(Arg, Lper), List =[['perm'|Lper]]) ;
																List=[[H]].

check_negation_effects([], []).
check_negation_effects([H|T], L) :- H == [], L=[].
check_negation_effects([H|T], L) :- H \== [], check_head_negation_effects(H, ListHead),
														check_negation_effects(T,Ltail), append(ListHead, Ltail, L).
check_head_negation_effects([], []).
check_head_negation_effects(H, List) :-	functor(H, Name, _), %write('functor name '), write(Name), nl,
																(Name = '-') -> H =.. L, replace('-', 'neg', L, Lf), List = Lf ; %List=[H],
																(functor(H, Name, Arity), Name = 'o') -> (arg(1, H, Arg), check_head_negation(Arg, Lobl), List =['obl'|Lobl]) ;
																(functor(H, Name, Arity), Name = 'p') -> (arg(1, H, Arg), check_head_negation(Arg, Lper), List =['perm'|Lper]) ;
																List=[H].

replace(_, _, [],[]).
replace(O, R, [O|T], [R|T2]) :- replace(O, R, T, T2).
replace(O, R, [H|T], [H|T2]) :- H \= O, replace(O, R, T, T2).
