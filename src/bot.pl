
choose_move(Board-(PurpleWon1-GreenWon1-OrangeWon1-PurpleWon2-GreenWon2-OrangeWon2), Player, Level, Move) :-
    valid_moves(Board, ListOfMoves),
    (
        (
            Level == 'random',
            random_member(Move, ListOfMoves)
        );
        (
            Level == 'greedy',
            colourWonBoth(PurpleWon1, PurpleWon2, PurpleWon),
            colourWonBoth(GreenWon1, GreenWon2, GreenWon),
            colourWonBoth(OrangeWon1, OrangeWon2, OrangeWon),
            findall(Value-Move1, ( member(Move1, ListOfMoves), updateBoard(Board, Move1, NewBoard), value(NewBoard-(PurpleWon-GreenWon-OrangeWon), Player, Value)), ValueMoveList),
            %write(ValueMoveList),
            max_member(_-Move, ValueMoveList)
        )
    ).

colourWonBoth(Colour1, Colour2, Result) :-
    (
        (
            Colour1 == 'TRUE';
            Colour2 == 'TRUE'
        ), Result = 'TRUE'
    );
    Result = 'FALSE'.


valid_moves(Board, ListOfMoves) :-
    % searchBoard(NewBoard, List, 1).
    searchBoard(Board, [], List, 1),
    findall(Move, (member(Move, List), checkValidMove(Board, Move)), ListOfMoves).


checkValidMove(Board, [Row, Diagonal, Colour]) :-
    checkEmpty([Row, Diagonal, Colour], Board),
    checkAvailableDisc(Board, Colour).



    