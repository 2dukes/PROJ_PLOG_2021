valid_moves(Board, Player, ListOfMoves) :-
    % searchBoard(NewBoard, List, 1).
    searchBoard(Board, [], List, 1),
    write(List),
    findall(Move, (member(Move, List), checkValidMove(Board, Move)), ListOfMoves).


checkValidMove(Board, [Row, Diagonal, Colour]) :-
    checkEmpty([Row, Diagonal, Colour], Board),
    checkAvailableDisc(Board, Colour).

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
    

    