:- use_module(library(lists)).

% Number unmodified
presentNum(_, _, Number) :-
    Number < 10, 
    write('  '), write(Number), write('  |'). 

% Added Number on the left
presentNum(Original, Original, Number) :-
    write(' '), write(Number), write('  |').

% Added Number on the right
presentNum(_, _, Number) :-
    write('  '), write(Number), write(' |'). 

presentResult_Line([], []).
presentResult_Line([FOriginal | RestOriginal], [First | Rest]) :-
    % write(FOriginal), write(RestOriginal),
    RigthDigit is mod(First, 10),
    presentNum(FOriginal, RigthDigit, First),
    presentResult_Line(RestOriginal, Rest).
    
presentResult([], []).
presentResult([FOriginal | RestOriginal], [First | Rest]) :-
    write('|'),
    presentResult_Line(FOriginal, First),
    nl,
    presentResult(RestOriginal, Rest).