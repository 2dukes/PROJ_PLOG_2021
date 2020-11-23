
choose_move(Board-(PurpleWon1-OrangeWon1-GreenWon1-PurpleWon2-OrangeWon2-GreenWon2), Player, Level, Move) :-
    valid_moves(Board-(PurpleWon1-OrangeWon1-GreenWon1-PurpleWon2-OrangeWon2-GreenWon2), ListOfMoves),
    write('Length: '), length(ListOfMoves, A), write(A),nl,
    (
        (
            % sleep(2),
            Level == 'random',
            random_member(Move, ListOfMoves)
        );
        (
            Level == 'greedy',
            colourWonBoth(PurpleWon1, PurpleWon2, PurpleWon),
            colourWonBoth(GreenWon1, GreenWon2, GreenWon),
            colourWonBoth(OrangeWon1, OrangeWon2, OrangeWon),
            findall(Value-Move1, ( member(Move1, ListOfMoves), updateBoard(Board, Move1, NewBoard), value(NewBoard-(PurpleWon-OrangeWon-GreenWon), Player, Value) ), ValueMoveList),
            % write(ValueMoveList),
            

            max_member(ValueMax-_, ValueMoveList),
            findall(Value1-MoveBest, (member(Value1-MoveBest, ValueMoveList), Value1 == ValueMax), BestMoves),
            random_member(_-ChosenMove, BestMoves),
            write('Length: '), length(ValueMoveList, Length), write(Length),nl,
            Move = ChosenMove
        )
    ).

colourWonBoth('TRUE', _, 'TRUE').
colourWonBoth(_, 'TRUE', 'TRUE').
colourWonBoth('FALSE', 'FALSE', 'FALSE').

valid_moves(Board-(PurpleWon1-OrangeWon1-GreenWon1-PurpleWon2-OrangeWon2-GreenWon2), ListOfMoves) :-
    % searchBoard(NewBoard, List, 1).
    searchBoard(Board, [], List, 1),
    findall(Move, 
        (
            member(Move, List), 
            checkValidMove(Board-(PurpleWon1-OrangeWon1-GreenWon1-PurpleWon2-OrangeWon2-GreenWon2), Move)
        ), ListOfMoves).


checkValidMove(Board-(PurpleWon1-OrangeWon1-GreenWon1-PurpleWon2-OrangeWon2-GreenWon2), [Row, Diagonal, Colour]) :-
    checkEmpty([Row, Diagonal, Colour], Board),
    checkAvailableDisc(Board-(PurpleWon1-OrangeWon1-GreenWon1-PurpleWon2-OrangeWon2-GreenWon2), Colour).



    