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

decrementN(N, 0, NewN, OriginalM, OriginalM) :-
    NewN is N - 1, nl.

decrementN(NewN, M, NewN, M, _).

% Present Solution
presentResult([], [], 0, _, _).
presentResult([Original | RestOriginal], [First | Rest], N, M, OriginalM) :- % Input | Result
    write('|'),
    RigthDigit is mod(First, 10),
    presentNum(Original, RigthDigit, First),
    NewM is M - 1,
    decrementN(N, NewM, NewN, NewMAgain, OriginalM),
    presentResult(RestOriginal, Rest, NewN, NewMAgain, OriginalM).

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

cNote(N, M, InputGrid, DynamicGrid, DigitGrid) :-
    % write(DynamicGrid),
    applyConstraints(InputGrid, DigitGrid, DynamicGrid),
    flattenGrid(DynamicGrid, [], ResultGrid),
    reset_timer,
    % time_out(labeling([], ResultGrid), 1000, Res),
    % write(Res),
    labeling([time_out(5000, Flag)], ResultGrid),
    finalCNote(Flag, InputGrid, ResultGrid, N, M).
   
    
cNote(_, _, _, _, _) :- write('No solution found!'), nl.

finalCNote(success, InputGrid, ResultGrid, N, M) :-
    print_time,
	fd_statistics,
    write(ResultGrid),nl,
    flattenGrid(InputGrid, [], Input),
    presentResult(Input, ResultGrid, N, M, M).

finalCNote(time_out, _, _, _, _) :-
    write('No solutions found withing 5s!'), nl.

% 18 | 8 
% 18 % 10  = 8 -> LEFT
% 81 % 10 != 8 -> RIGHT

applyConstraintsLine([], [], []).
applyConstraintsLine([H|T], [S|T2], [R|T1]) :- % Input | Digits | Result    
    S in 0..9,                      
    R in 1..99,                                                                             % / \
    R #= H*10 + S #\/ R #= S*10 + H, %#\/ (R #= H #/\ S #= 0), #atencao caso q n se mete nada / ! \
    applyConstraintsLine(T, T2, T1).                                                       % /_____\

applySumConstraintsLines([], [], []).
applySumConstraintsLines([Prob|ProbRest], [Sol|SolRest], [Line|Rest]) :-
    sum(Line, #=, 100),
    applyConstraintsLine(Prob, Sol, Line),
    applySumConstraintsLines(ProbRest, SolRest, Rest).

% [[1, 2], [3, 4]]
applySumConstraintsColumns(_, 0) :- !.
applySumConstraintsColumns(Grid, Ncol) :-
    applySumConstraintsColumnsAux(Grid, Ncol, [], Result),
    sum(Result, #=, 100),
    NewNcol is Ncol - 1,
    applySumConstraintsColumns(Grid, NewNcol).

applySumConstraintsColumnsAux([], _, Result, Result).
applySumConstraintsColumnsAux([Line | Rest], Ncol, Aux, Result) :-
    element(Ncol, Line, Element),
    append(Aux, [Element], NewAux),
    applySumConstraintsColumnsAux(Rest, Ncol, NewAux, Result).

applyConstraints(Prob, Sol, Res) :- % Input | Digits | Result  
    applySumConstraintsLines(Prob, Sol, Res),
    nth1(1, Prob, Line),
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
    generateGrid(N-M, [], InputGrid, 'TRUE'), % Read Input Puzzle
    generateGrid(N-M, [], DynamicGrid, 'FALSE'), % Generate Dynamic List
    generateGrid(N-M, [], DigitGrid, 'FALSE'), % Generate Digit List
    !, cNote(N, M, InputGrid, DynamicGrid, DigitGrid).