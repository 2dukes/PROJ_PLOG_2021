:- use_module(library(lists)).
:- use_module(library(clpfd)).
:- use_module(library(random)).
:- consult('utils.pl').
:- consult('generate.pl').
:- consult('menu.pl').

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

% Decrements the line counter
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

% Get line length and line from input
gridLine('TRUE', LineGrid, M) :-
    write('Enter your Line: '),
    getLine(LineGrid, M).

% Set the length of a line
gridLine('FALSE', LineGrid, M) :-
    length(LineGrid, M).

% Generate an empty grid or grid from input
generateGrid(0-_, Grid, Grid, _) :- !.
generateGrid(N-M, Aux, Grid, ReadInput) :-
    gridLine(ReadInput, LineGrid, M),
    append(Aux, [LineGrid], NewAux),
    NewN is N - 1,
    generateGrid(NewN-M, NewAux, Grid, ReadInput).

% CNote core predicate 
cNote(InputGrid, DynamicGrid, DigitGrid, ResultGrid, Flag, Timeout, Option) :-
    applyConstraints(InputGrid, DigitGrid, DynamicGrid),
    flattenGrid(DynamicGrid, [], ResultGrid),
    reset_timer,
    labelCNote(ResultGrid, Timeout, Flag, Option).

% CNote core predicate when no solutions where found for the given puzzle
cNote(_, _, _, _, nosolutions, _, _).

% Labeling (solver)
labelCNote(ResultGrid, _, _, solvePuzzle) :-
    labeling([ff, ffc], ResultGrid).

% Labeling (generator)
labelCNote(ResultGrid, Timeout, Flag, generatePuzzle) :-
    labeling([time_out(Timeout, Flag), value(selRandomValue), variable(selRandomVariable)], ResultGrid).

% Apply constraints related to a single cell
applyConstraintsLine([], [], []).
applyConstraintsLine([H|T], [S|T2], [R|T1]) :- % Input | Digits | Result 
    H in 1..9,
    S in 0..9,                      
    R in 1..99,                      
    R #= H*10 + S #\/ R #= S*10 + H, 
    applyConstraintsLine(T, T2, T1). 

% Apply line constraints 
applySumConstraintsLines([], [], []).
applySumConstraintsLines([Prob|ProbRest], [Sol|SolRest], [Line|Rest]) :-
    sum(Line, #=, 100),
    applyConstraintsLine(Prob, Sol, Line),
    applySumConstraintsLines(ProbRest, SolRest, Rest).

% Apply constrains per column (sum of column has to be 100)
applySumConstraintsColumns(_, 0) :- !.
applySumConstraintsColumns(Grid, Ncol) :-
    applySumConstraintsColumnsAux(Grid, Ncol, [], Column),
    sum(Column, #=, 100),
    NewNcol is Ncol - 1,
    applySumConstraintsColumns(Grid, NewNcol).

% Apply column constrains 
applySumConstraintsColumnsAux([], _, Result, Result).
applySumConstraintsColumnsAux([Line | Rest], Ncol, Aux, Result) :-
    element(Ncol, Line, Element),
    append(Aux, [Element], NewAux),
    applySumConstraintsColumnsAux(Rest, Ncol, NewAux, Result).

% Apply all constraints 
applyConstraints(Prob, Sol, Res) :- % Input | Digits | Result  
    applySumConstraintsLines(Prob, Sol, Res),
    nth1(1, Prob, Line),
    length(Line, Ncols),
    applySumConstraintsColumns(Res, Ncols).
  
% Flattens a 2 dimension grid into a 1 dimension grid
flattenGrid([], Result, Result).
flattenGrid([Line|Rest], Aux, Result) :-
    append(Aux, Line, NewAux),
    flattenGrid(Rest, NewAux, Result).

% Solve puzzle given by the user
solveCNote :-
    readPuzzleInput(N, M),
    generateGrid(N-M, [], InputGrid, 'TRUE'), % Read Input Puzzle
    generateGrid(N-M, [], DynamicGrid, 'FALSE'), % Generate Dynamic List
    generateGrid(N-M, [], DigitGrid, 'FALSE'), % Generate Digit List
    !,
    cNote(InputGrid, DynamicGrid, DigitGrid, ResultGrid, Flag, 5000, solvePuzzle),
    finalCNote(Flag, InputGrid, ResultGrid, N, M).

% Generate a random puzzle
generateCNote :-
    readPuzzleInput(N, M),
    generateGrid(N-M, [], InputGrid, 'FALSE'), % Read Input Puzzle
    generateGrid(N-M, [], DynamicGrid, 'FALSE'), % Generate Dynamic List
    generateGrid(N-M, [], DigitGrid, 'FALSE'), % Generate Digit List
    !,
    cNote(InputGrid, DynamicGrid, DigitGrid, ResultGrid, Flag, 5000, generatePuzzle),
    finalCNote(Flag, InputGrid, ResultGrid, N, M).

% Solve one of the hard coded puzzles
hardCNote :-
    write('Insert the puzzle number: '),
    getInt(PuzzleN),
    puzzle(PuzzleN, N, M, InputGrid), % Selected Puzzle
    generateGrid(N-M, [], DynamicGrid, 'FALSE'), % Generate Dynamic List
    generateGrid(N-M, [], DigitGrid, 'FALSE'), % Generate Digit List
    !,
    write(InputGrid),
    cNote(InputGrid, DynamicGrid, DigitGrid, ResultGrid, Flag, 5000, solvePuzzle),
    finalCNote(Flag, InputGrid, ResultGrid, N, M).

% Prints statistics and the result grid
finalCNote(success, InputGrid, ResultGrid, N, M) :-
    print_time,
	fd_statistics,
    flattenGrid(InputGrid, [], Input),
    presentResult(Input, ResultGrid, N, M, M).

% Displayed when no solutions were found within the given timeout
finalCNote(time_out, _, _, _, _) :-
    nl, write('No solutions found within 5s!'), nl.

% Displayed when no solutions were found
finalCNote(nosolutions, _, _, _, _) :-
    nl, write('No solutions found!'), nl.

% Puzzle start
cnote :-
    mainMenu.