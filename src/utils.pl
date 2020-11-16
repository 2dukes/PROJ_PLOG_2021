getInt(Int) :- 
    repeat,
    (
        (
            catch(read(Int), _, true),
            read_line(_),
            integer(Int),
            nl
        );
        (
            write('Invalid input!'), nl, % write(Int),%Insert number: '),
            fail
        )
    ).

getChar(Char) :-
    get_char(Char),
    read_line(_),
    nl.

% replaceNth(+List, +Index, +Value, -NewList).
replaceNth([_|T], 0, X, [X|T]).
replaceNth([H|T], I, X, [H|R]):- I > -1, NI is I-1, replaceNth(T, NI, X, R), !.
replaceNth(L, _, _, L).


% countOccurrence(+List, +Value, -Count)
countOccurrence([] , _,0). % empty list, count of anything is 0. Base case.

countOccurrence([H|T] , H,NewCount):-
    countOccurrence(T,H, OldCount),
    NewCount is OldCount + 1.

countOccurrence([H|T], H2, Count):-
    H \= H2, 
    countOccurrence(T,H2,Count).

execute(Function, Args) :-
    Run =.. [Function | Args], 
    Run.

countDiscs([], 0, 0, 0).
countDiscs([Line | Rest], OrangeDiscs, GreenDiscs, PurpleDiscs) :-
    countOccurrence(Line, orange, AuxOrangeDiscs),
    countOccurrence(Line, green, AuxGreenDiscs),
    countOccurrence(Line, purple, AuxPurpleDiscs),
    countDiscs(Rest, Oranges, Greens, Purples),
    OrangeDiscs is Oranges + AuxOrangeDiscs,
    GreenDiscs is Greens + AuxGreenDiscs,
    PurpleDiscs is Purples + AuxPurpleDiscs.


searchBoard(_, List, ResultAll, LineCounter) :- LineCounter == 24, ResultAll = List.
searchBoard(Board, List, ResultAll, LineCounter) :-
    LineCounter =< 23,
    nth1(LineCounter, Board, Line),
    length(Line, LineLength),
    startDiag(LineCounter, StartDiagonal),
    lookUpLine(LineCounter, StartDiagonal, LineLength, [], Result, 0),
    append(List, Result, NewList),
    NewLineCounter is LineCounter + 1,
    searchBoard(Board, NewList, ResultAll, NewLineCounter).

lookUpLine(_, _, LineLength, List, Result, Index) :- Index == LineLength, Result = List.
lookUpLine(LineCounter, StartDiagonal, LineLength, List, Result, Index) :-
    Index < LineLength,
    (
        NewDiagonal is StartDiagonal + Index,

        append(List, [[LineCounter, NewDiagonal, green]], NewList),
        append(NewList, [[LineCounter, NewDiagonal, orange]], NewList1),
        append(NewList1, [[LineCounter, NewDiagonal, purple]], NewList2)
    ),
    NewIndex is Index + 1,
    lookUpLine(LineCounter, StartDiagonal, LineLength, NewList2, Result, NewIndex).
    
    
clearConsole :- write('\33\[2J').
