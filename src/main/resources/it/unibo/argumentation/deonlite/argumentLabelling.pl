% ----------------------------------------------------------------
% argumentLabelling.pl
% PIKA-lab
% Year: 2019
% ---------------------------------------------------------------


argumentLabelling([Arguments, _, _], [IN, OUT, UND]) :-
    labelArguments(Arguments, [], [], [], IN, OUT, UND),
    printArgumentLabelling( [IN, OUT, UND] ).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

labelArguments([], _, IN, OUT, IN, OUT, []).

labelArguments(Ai, Ai,  IN, OUT, IN, OUT, Ai).

labelArguments(Ai, _, IN, OUT, ResultIN, ResultOUT, ResultUND) :-

   findall(A, ( member(A, Ai), allAttacksOUT(A, OUT) ), NewListIN),
   append(IN, NewListIN, NewIN),

   findall(A, ( member(A, Ai), oneAttackIN(A, NewIN) ), NewListOUT),
   append(OUT, NewListOUT, NewOUT),

   append(NewIN, NewOUT, NewLabelledArguments),
   subtract(Ai, NewLabelledArguments, AiPlus1),

   labelArguments(AiPlus1, Ai, NewIN, NewOUT, ResultIN, ResultOUT, ResultUND).


allAttacksOUT(A, OUT) :-
    \+ ( attack(B, A),
    \+ ( member(B, OUT))
       ).

oneAttackIN(A, IN) :-
    attack(B, A),
    member(B, IN), !.
