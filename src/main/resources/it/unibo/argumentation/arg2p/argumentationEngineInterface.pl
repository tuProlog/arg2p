% ----------------------------------------------------------------
% argumentationEngineInterface.pl
% PIKA-lab
% Year: 2019
% ---------------------------------------------------------------

go :-
    buildArgumentationGraph([Arguments, Attacks, Supports] ),
    argumentLabelling([Arguments, Attacks, Supports], [IN, OUT, UND]),
    statementLabelling([IN, OUT, UND], _).
    
go([In, No, Und]) :-
    buildArgumentationGraph([Arguments, Attacks, Supports] ),
    argumentLabelling([Arguments, Attacks, Supports], [IN, OUT, UND]),
    statementLabelling([IN, OUT, UND], [In, No, Und]), !.


%go([In, No, Und]) :-
%    time(buildArgumentationGraph([Arguments, Attacks, Supports] )), %Execute Goal just like call/1 and print time used
%    time(argumentLabelling([Arguments, Attacks, Supports], [IN, OUT, UND])),
%    time(statementLabelling([IN, OUT, UND], [In, No, Und])), !.
