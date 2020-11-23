
choose_move(Board-(PurpleWon1-OrangeWon1-GreenWon1-PurpleWon2-OrangeWon2-GreenWon2), Player, Level, Move) :-
    valid_moves(Board, ListOfMoves),
    write('Length: '), length(ListOfMoves, A), write(A),nl,
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
            findall(Value-Move1, ( member(Move1, ListOfMoves), updateBoard(Board, Move1, NewBoard), value(NewBoard-(PurpleWon-GreenWon-OrangeWon), Player, Value) ), ValueMoveList),
            % write(ValueMoveList),
            

            max_member(Value1-ChosenMove, ValueMoveList),
            write('Length: '), length(ValueMoveList, Length), write(Length),nl,

            % write(Value1),nl,
            (
                (
                    Value == 0,
                    random_member(Move, ListOfMoves)
                );
                Move = ChosenMove
            )
        )
    ).

colourWonBoth('TRUE', _, 'TRUE').
colourWonBoth(_, 'TRUE', 'TRUE').
colourWonBoth('FALSE', 'FALSE', 'FALSE').

valid_moves(Board, ListOfMoves) :-
    % searchBoard(NewBoard, List, 1).
    searchBoard(Board, [], List, 1),
    findall(Move, (member(Move, List), checkValidMove(Board, Move)), ListOfMoves).


checkValidMove(Board, [Row, Diagonal, Colour]) :-
    checkEmpty([Row, Diagonal, Colour], Board),
    checkAvailableDisc(Board, Colour).



    