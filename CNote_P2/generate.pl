# generateRow(0, Result, Result) :- !.
# generateRow(M, Aux, Result) :-
#     random(1, 10, Random),
#     append(Aux, [Random], NewAux),
#     NewM is M - 1,
#     generateRow(NewM, NewAux, Result).

# geneRandomPuzzleLines(0, _, Result, Result) :- !.
# geneRandomPuzzleLines(N, M, Aux, Result) :-
#     generateRow(M, [], ResultRow),
#     append(Aux, [ResultRow], NewAux),
#     NewN is N - 1,
#     geneRandomPuzzleLines(NewN, M, NewAux, Result).

# printR(success, true).
# printR(_, false).

# % [[1, 2], [3, 4]]
# generateRandomPuzzle(N, M) :- 
#     repeat, 
#     geneRandomPuzzleLines(N, M, [], InputPuzzle), % Input Grid
#     generateGrid(N-M, [], DynamicGrid, 'FALSE'), % Generate Dynamic List
#     generateGrid(N-M, [], DigitGrid, 'FALSE'), % Generate Digit List
    
#     cNote(InputPuzzle, DynamicGrid, DigitGrid, ResultGrid, Flag, 500),
#     printR(Flag, PrintResult),
#     finalCNote(Flag, InputPuzzle, ResultGrid, N, M, PrintResult).
#     % write(ResultPuzzle).