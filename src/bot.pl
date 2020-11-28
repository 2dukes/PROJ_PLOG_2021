
% Escolhe a jogada a efetuar pelo computador para o nível Level (Random ou Greedy)
choose_move(GameState, Player, Level, Move) :-
    valid_moves(GameState, ListOfMoves),
    getMove(GameState, Level, ListOfMoves, Move, Player).

getMove(_, random, ListOfMoves, Move, _) :- 
    % sleep(2),
    random_member(Move, ListOfMoves).

getMove(Board-(PurpleWon1-OrangeWon1-GreenWon1-PurpleWon2-OrangeWon2-GreenWon2), greedy, ListOfMoves, Move, Player) :-
    colourWonBoth(PurpleWon1, PurpleWon2, PurpleWon),
    colourWonBoth(GreenWon1, GreenWon2, GreenWon),
    colourWonBoth(OrangeWon1, OrangeWon2, OrangeWon),
    findall(Value-Move1, ( 
        member(Move1, ListOfMoves), updateBoard(Board, Move1, NewBoard), value(NewBoard-(PurpleWon-OrangeWon-GreenWon), Player, Value) 
    ), ValueMoveList),
    max_member(ValueMax-_, ValueMoveList),
    findall(Value1-MoveBest, (member(Value1-MoveBest, ValueMoveList), Value1 == ValueMax), BestMoves),
    random_member(_-ChosenMove, BestMoves),
    Move = ChosenMove.

% Verifica se uma cor já foi ganha (para depois não a processar no algoritmo de path finding do bot)
colourWonBoth('TRUE', _, 'TRUE').
colourWonBoth(_, 'TRUE', 'TRUE').
colourWonBoth('FALSE', 'FALSE', 'FALSE').

% Obtém a lista de moves válidos para a próxima jogada 
valid_moves(Board-(PurpleWon1-OrangeWon1-GreenWon1-PurpleWon2-OrangeWon2-GreenWon2), ListOfMoves) :-
    % searchBoard(NewBoard, List, 1).
    searchBoard(Board, [], List, 1),
    findall(Move, 
        (
            member(Move, List), 
            checkValidMove(Board-(PurpleWon1-OrangeWon1-GreenWon1-PurpleWon2-OrangeWon2-GreenWon2), Move)
        ), ListOfMoves).

% Verifica se uma jogada é válida; isto é, se a célula está vazia e se existem discos suficientes para efetuar essa jogada.
checkValidMove(Board-(PurpleWon1-OrangeWon1-GreenWon1-PurpleWon2-OrangeWon2-GreenWon2), [Row, Diagonal, Colour]) :-
    checkEmpty([Row, Diagonal, Colour], Board),
    checkAvailableDisc(Board-(PurpleWon1-OrangeWon1-GreenWon1-PurpleWon2-OrangeWon2-GreenWon2), Colour).



    