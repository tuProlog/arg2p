% ----------------------------------------------------------------
% Debug.pl
%
% Coder: Regis Riveret
% Year: 2019
% ---------------------------------------------------------------


pleaseDebug :-
    asserta(debugDeonLite).

pleaseNoDebug :-
    retractall(debugDeonLite).

% ========================================================================

printTheory :-
    debugDeonLite,
    writeln('HERE THE THEORY:'),
    findall(rule([Id, Body, Head]), rule([Id, Body, Head]), ListRules),
    writeList(ListRules),
    writeln(' '),
    findall(conflict(A, B), conflict(A, B), ListConflicts),
    writeList(ListConflicts),
    writeln(' '),
    findall(sup(A, B), sup(A, B), ListSups),
    writeList(ListSups),
    writeln(' ').

printTheory.


% ========================================================================

printArgumentationGraph :-
        debugDeonLite,
	findall( [IDPremises, '\n',  ' TOPRULE ',  TopRule, '\n', ' CONCLUSION ', RuleHead, '\n'],
                 (   argument([IDPremises, TopRule, RuleHead]),
                     ground(argument([IDPremises, TopRule, RuleHead]))   ),
                  ArgumentsToPrint),
        findall( (A1, ' SUPPORTS ', A2), support(A1, A2), SupportsToPrint),
	findall( (A1, ' ATTACKS ', A2),  attack(A1, A2),  AttacksToPrint),


        writeln('HERE THE GROUNDED SEMI-ABSTRACT ARGUMNETATION GRAPH'),
	writeList(ArgumentsToPrint), writeln(' '),
	writeList(SupportsToPrint), writeln(' '),
	writeList(AttacksToPrint).

printArgumentationGraph.


% ========================================================================

printArgumentLabelling(  [IN, OUT, UND] ) :-
    debugDeonLite,
    writeln('    '),
    writeln('HERE THE ARGUMENTS LABELLED IN: '),
    writeList(IN),
    writeln('    '),
    writeln('HERE THE ARGUMENTS LABELLED OUT: '),
    writeList(OUT),
    writeln('    '),
    writeln('HERE THE ARGUMENTS LABELLED UND: '),
    writeList(UND).

printArgumentLabelling( _ ).

% ========================================================================

printStatementLabelling(  [In, Ni, Und] ) :-
    debugDeonLite,
    writeln('    '),
    writeln('HERE THE STATEMENTS LABELLED IN: '),
    writeList(In),
    writeln('    '),
    writeln('HERE THE STATEMENTS LABELLED NI: '),
    writeList(Ni),
    writeln('    '),
    writeln('HERE THE STATEMENTS LABELLED UND: '),
    writeList(Und).


printStatementLabelling(  _ ).



% -----------------------------------------------------------------------------
% E O F -- E O F -- E O F -- E O F -- E O F -- E O F -- E O F -- E O F -- E O F
% -----------------------------------------------------------------------------
