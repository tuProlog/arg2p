% ----------------------------------------------------------------
% argumentationEngineInterface.pl
%
% PIKA-LAB
% Year: 2019
% ---------------------------------------------------------------


% Literals statments have the following form.
% literals: [atom] or [neg, atom]
% deontic literals: [obl, [atom]] or [obl, [neg, atom]] or [neg, obl,[neg, atom]] or [perm, [neg, atom]]
%========================================================================

conflict( [Atom], [neg, Atom]).
conflict( [neg, Atom], [Atom]).

conflict( [obl, [Atom]],  [obl, [neg, Atom]]).
conflict( [obl, [neg, Atom]],  [obl, [Atom]]).

conflict( [obl, Lit],  [neg, obl, Lit]).
conflict( [neg, obl, Lit],  [obl, Lit]).

conflict( [perm, [Atom]],  [obl, [neg, Atom]]).
conflict( [obl, [neg, Atom]],  [perm, [Atom]]).

conflict( [perm, [neg, Atom]],  [obl, [Atom]]).
conflict( [obl, [Atom]],  [perm, [neg, Atom]]).


%========================================================================
buildArgumentationGraph([Arguments, Attacks, Supports] ) :-
        retractall(argument(_)), !,
        retractall(attack(_, _)), !,
	retractall(support(_, _)), !,
	buildArguments,
        buildAttacks,

        findall( [IDPremises,  TopRule,  RuleHead],
                 ( argument([IDPremises, TopRule, RuleHead]),
                   ground(argument([IDPremises, TopRule, RuleHead])) ),
                 Arguments),
        findall( (A1, A2), support(A1, A2), Supports),
	findall( (A1, A2), attack(A1, A2),  Attacks),

        printArgumentationGraph.


%==================================

buildArguments :-
	rule([RuleID, RuleBody, RuleHead]),
	ruleBodyIsSupported(RuleBody, [], [], PremisesOfSupportingArguments, Supports),
	append([RuleID], PremisesOfSupportingArguments, IDPremises),
	sort(IDPremises, SortedPremises), % Also remove duplicates
        NewArgument = [SortedPremises, RuleID, RuleHead],
	\+ argument(NewArgument),
	assertSupports(Supports, NewArgument),
	asserta(argument(NewArgument)),
        buildArguments.

buildArguments.


%==================================

ruleBodyIsSupported([], ResultPremises, ResultSupports, ResultPremises, ResultSupports).
ruleBodyIsSupported([ [unless, _] | Others], Premises, Supports, ResultPremises, ResultSupports) :-
	ruleBodyIsSupported(Others, Premises, Supports, ResultPremises, ResultSupports).
ruleBodyIsSupported([ Statement | Others], Premises, Supports, ResultPremises, ResultSupports) :-
        argument([ArgumentID, RuleID, Statement]),
	append(ArgumentID, Premises, NewPremises),
	append([[ArgumentID, RuleID, Statement]], Supports, NewSupports),
	ruleBodyIsSupported(Others, NewPremises, NewSupports, ResultPremises, ResultSupports).


assertSupports([], _).
assertSupports([Support | OtherSupports], Argument) :-
	asserta(support(Support, Argument)),
	assertSupports(OtherSupports, Argument).


%==================================
buildAttacks :-
	argument([IDPremisesA, RuleA, RuleHeadA]),
	argument([IDPremisesB, RuleB, RuleHeadB]),
        sub([IDPremisesB, RuleB, RuleHeadB], Subs),
        member([IDPremisesSubB, RuleSubB, RuleHeadSubB], Subs),

        conflict(RuleHeadA, RuleHeadSubB),
        rebuts([IDPremisesA, RuleA, RuleHeadA], [IDPremisesSubB, RuleSubB, RuleHeadSubB]),

	\+( attack([IDPremisesA, RuleA, RuleHeadA], [IDPremisesB, RuleB, RuleHeadB]) ),
	asserta( attack([IDPremisesA, RuleA, RuleHeadA], [IDPremisesB, RuleB, RuleHeadB]) ),
	fail.

buildAttacks :-
	argument([IDPremisesA, RuleA, RuleHeadA]),
	argument([IDPremisesB, RuleB, RuleHeadB]),
        undercuts([IDPremisesA, RuleA, RuleHeadA], [IDPremisesB, RuleB, RuleHeadB]),
	\+( attack([IDPremisesA, RuleA, RuleHeadA], [IDPremisesB, RuleB, RuleHeadB]) ),
	asserta( attack([IDPremisesA, RuleA, RuleHeadA], [IDPremisesB, RuleB, RuleHeadB]) ),
	fail.

buildAttacks :-
	attack(A, B),
	support(B, C),
	\+ attack(A, C),
	asserta( attack(A, C)),
        buildAttacks.

buildAttacks.


%--------------------------------------------------

sub(B, [B |Subs]) :-
       findall(Sub,  support(Sub, B), Subs ).

rebuts(A, B) :-
        \+ superiorArgument(B, A).

superiorArgument([_, TopRuleA, _], [_, TopRuleB, _ ]) :-
        sup(TopRuleA, TopRuleB).

undercuts([_, _, RuleHeadA], [_, RuleB, _]) :-
        rule([RuleB, Body, _]),
        member([unless, RuleHeadA], Body).
