% ----------------------------------------------------------------
% argumentLabelling.pl
% PIKA-lab
% Year: 2019
% ---------------------------------------------------------------


argumentGroundedDefeasiblePreferencesLabelling([Arguments, _, _], [IN, OUT, UND]) :-
    labelArgumentsGDP(Arguments, [], [], IN, OUT, UND), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

labelArgumentsGDP(UND, IN, OUT, ResultIN, ResultOUT, ResultUND) :-

   findall(A, ( member(A, UND), allAttacksOUT(A, OUT) ), NewListIN),
   append(IN, NewListIN, NewIN),
   findall(A, ( member(A, UND), oneAttackIN(A, NewIN) ), NewListOUT),
   append(OUT, NewListOUT, NewOUT),

   append(NewListIN, NewListOUT, NewLabelledArguments),
   \+ isEmptyList(NewLabelledArguments),

   subtract(UND, NewLabelledArguments, UndPlus1),
   labelArgumentsGDP(UndPlus1, NewIN, NewOUT, ResultIN, ResultOUT, ResultUND).

labelArgumentsGDP(UND, IN, OUT, IN, OUT, UND).

/*
    If an attack exists, it should come from an OUT argument
*/
allAttacksOUT(A, OUT) :-
    \+ ( attack(B, A), \+ ( member(B, OUT))).

/*
    Find an attack, if exists, from an IN argument, then ends
*/
oneAttackIN(A, IN) :-
    attack(B, A),
    member(B, IN), !.

% Se vado in IN controllo la possibile presenza di una indicazione di preferenza
%    sup(r1, r2)
%    se questo è il caso devo invalidare gli attacchi da r2 a r1
%       Arg(topRule r1) > Arg(topRule r2)
%       Arg(topRule r1) > TopArguments(Arg(topRule r2))
%       ->
%       retract : attack(Arg(topRule r2), Arg(topRule r1))
%       retract : foreach x in TopArguments(Arg(topRule r2)) -> attack(x, Arg(topRule r1))