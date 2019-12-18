% ----------------------------------------------------------------
% argumentationEngineInterface.pl
% PIKA-lab
% Year: 2019
% ---------------------------------------------------------------
    
buildLabelSets ([In, No, Und]) :-
    buildArgumentationGraph([Arguments, Attacks, Supports] ),
    argumentLabelling([Arguments, Attacks, Supports], [IN, OUT, UND]),
    statementLabelling([IN, OUT, UND], [In, No, Und]), !.

answerQuery(Goal, YesResult, NoResult, UndResult) :- convertAllRules,
													 buildLabelSets([In, Out, Und]),
													 findall(Goal, answerSingleQuery(Goal, In), YesResult),
													 findall(Goal, answerSingleQuery(Goal, Out), NoResult),
													 findall(Goal, answerSingleQuery(Goal, Und), UndResult).

answerSingleQuery(Goal, Set) :- member([Goal], Set).


%go([In, No, Und]) :-
%    time(buildArgumentationGraph([Arguments, Attacks, Supports] )), %Execute Goal just like call/1 and print time used
%    time(argumentLabelling([Arguments, Attacks, Supports], [IN, OUT, UND])),
%    time(statementLabelling([IN, OUT, UND], [In, No, Und])), !.


%buildLabelSets :-
%    buildArgumentationGraph([Arguments, Attacks, Supports] ),
%    argumentLabelling([Arguments, Attacks, Supports], [IN, OUT, UND]),
%    statementLabelling([IN, OUT, UND], _).
