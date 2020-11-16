valid_moves(Board, ListOfMoves) :-
    % searchBoard(NewBoard, List, 1).
    searchBoard(Board, [], List, 1),
    write(List),
    findall(Move, (member(Move, List), checkValidMove(Board, Move)), ListOfMoves).


checkValidMove(Board, [Row, Diagonal, Colour]) :-
    checkEmpty([Row, Diagonal, Colour], Board),
    checkAvailableDisc(Board, Colour).



    