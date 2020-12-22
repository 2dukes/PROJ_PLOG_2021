:- use_module(library(lists)).
:- use_module(library(clpfd)).
:- consult('utils.pl').

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

% Present Solution
presentResult([], []).
presentResult([FOriginal | RestOriginal], [First | Rest]) :-
    write('|'),
    presentResult_Line(FOriginal, First),
    nl,
    presentResult(RestOriginal, Rest).


gridLine('TRUE', LineGrid, M) :-
    write('Enter your Line: '),
    getLine(LineGrid, M).

gridLine('FALSE', LineGrid, M) :-
    length(LineGrid, M).

generateGrid(0-_, Grid, Grid, _).
generateGrid(N-M, Aux, Grid, ReadInput) :-
    gridLine(ReadInput, LineGrid, M),
    append(Aux, [LineGrid], NewAux),
    NewN is N - 1,
    generateGrid(NewN-M, NewAux, Grid, ReadInput).

% applyConstraintsCell([IFirst | IRest], [DFirst | DRest], [LRFirst | LRRest]) :-
%     DynamicFirst #= InputFirst + 

% applyConstraintsLine([ILine | IRest], [DLine | DRest], [LRLine | LRRest]) :-
%     applyConstraintsCell(ILine, DLine, LRLine),

cNote(N, M) :-
    generateGrid(N-M, [], InputGrid, 'TRUE'), % Read Input Puzzle
    generateGrid(N-M, [], DynamicGrid, 'FALSE'), % Generate Dynamic List
    generateGrid(N-M, [], DigitGrid, 'FALSE'), % Generate Digit List
    element(1, DynamicGrid, 2),
    write(DynamicGrid),
    domain(DigitGrid, 0, 9).
    % applyConstraintsLine(InputGrid, DynamicGrid, LeftOrRightGrid).


testMap(X, Y) :-
    Y #= 3 #\/ Y #= 4.

applyConstraints([H|T], )

test :-
    length(L, 3),
    domain(L, 1, 5),
    % maplist(testMap, L, Y),
    write('.'),
    labeling([all], L),
    write(L).

solveCNote :-
    write('Insert Number of Lines: '),
    getDimension(N),
    write('Insert Number of Columns: '),
    getDimension(M),
    cNote(N, M).