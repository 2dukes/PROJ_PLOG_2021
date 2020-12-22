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
    % write(DynamicGrid),
    applyConstraints(InputGrid, DigitGrid, DynamicGrid),
    flattenGrid(DynamicGrid, [], ResultGrid),
    labeling([], ResultGrid),
    write(ResultGrid).
    
    
% 18 | 8 
% 18 % 10  = 8 -> LEFT
% 81 % 10 != 8 -> RIGHT

applyConstraintsLines([], [], []).
applyConstraintsLines([H|T], [S|T2], [R|T1]) :- % Input | Digits | Result    
    S in 0..10,                      
    R in 0..100,                                                                             % / \
    R #= H*10 + S #\/ R #= S*10 + H, %#\/ (R #= H #/\ S #= 0), #atencao caso q n se mete nada / ! \
    applyConstraintsLines(T, T2, T1).                                                      % /_____\

applySumConstraintsLines([]).
applySumConstraintsLines([Line|Rest]) :-
    sum(Line, #=, 100),
    applySumConstraintsLines(Rest).

% [[1, 2], [3, 4]]
applySumConstraintsColumns([], 0).
applySumConstraintsColumns(Grid, Ncol) :-
    applySumConstraintsColumnsAux(Grid, Ncol, [], Result),
    sum(Result, #=, 100),
    NewNcol is NewNcol - 1,
    applySumConstraintsColumns(Grid, NewNcol).

applySumConstraintsColumnsAux([], _, Result, Result).
applySumConstraintsColumnsAux([Line | Rest], Ncol, Aux, Result) :-
    element(Ncol, Line, Element),
    append(Aux, [Element], NewAux),
    applySumConstraintsLinesAux(Rest, Ncol, NewAux, Result).

applyConstraints(Prob, Sol, Res) :- % Input | Digits | Result  
    applyConstraintsLines(Prob, Sol, Res),
    element(1, Prob, Line),
    length(Line, Ncols),
    applySumConstraintsColumns(Res, Ncols).
    
flattenGrid([], Result, Result).
flattenGrid([Line|Rest], Aux, Result) :-
    append(Aux, Line, NewAux),
    flattenGrid(Rest, NewAux, Result).

solveCNote :-
    write('Insert Number of Lines: '),
    getDimension(N),
    write('Insert Number of Columns: '),
    getDimension(M),
    cNote(N, M).

% testMap(X, Y) :-
%     Y #= 3 #\/ Y #= 4.

% test :-
%     length(L, 3),
%     domain(L, 1, 5),
%     % maplist(testMap, L, Y),
%     write('.'),
%     labeling([all], L),
%     write(L).