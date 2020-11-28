% Neste ficheiro estão presentes os predicados principais para o funcionamento do jogo, incluindo o game loop para executar jogadas 
% e atualizar o estado do jogo

% Start Game (Direciona para o Menu principal)
startGame(GameState) :-
    mainMenu(GameState).

% Verifica se a jogada é válida, isto é se a célula a jogar está vazia e se existem discos disponíveis para efetuar a jogada
checkValidPlay(Board-ColoursWon, [Row, Diagonal, Colour]) :-
    checkEmptyPlay([Row, Diagonal, Colour], Board),
    checkAvailableDiscAux(Board-ColoursWon, Colour). 

checkEmptyPlay(Move, Board) :-
    checkEmpty(Move, Board),!.

checkEmptyPlay(_, _) :-
    write('Cell not empty!'), nl, fail.

checkAvailableDiscAux(Board-ColoursWon, Colour) :-
    checkAvailableDisc(Board-ColoursWon, Colour), !.  

checkAvailableDiscAux(_, Colour) :-
    write('No more '), write(Colour), write(' discs remaining!'), nl, fail.
    
% Parse dos discos disponíveis para jogar
checkAvailableDisc(Board-ColoursWon, Colour) :-
    countDiscs(Board-ColoursWon, O, G, P),
    checkColourDiscs(Colour, P-O-G).

checkColourDiscs(orange, _-Existing-_) :-
    Available is 42 - Existing,
    Available > 0.

checkColourDiscs(green, _-_-Existing) :-
    Available is 42 - Existing,
    Available > 0.

checkColourDiscs(purple, Existing-_-_) :-
    Available is 42 - Existing,
    Available > 0.

% Imprime a jogada efetuada
print_move([Row, Diagonal, Colour]) :-
    write('Played R:'), write(Row),
    write(', D:'), write(Diagonal),
    write(', '), write(Colour), nl.

% Jogada de um Player
userPlay(GameState, NewGameState, _-p) :-
    repeat,
    (
        getUserInput(Row, Diagonal, Colour),
        move(GameState, [Row, Diagonal, Colour], NewGameState)
        %print_move([Row, Diagonal, Colour])
    ).

% Jogada de um Computador
userPlay(GameState, NewGameState, Nplayer-(c-Level)) :-
    choose_move(GameState, Nplayer, Level, Move),
    move(GameState, Move, NewGameState),
    print_move(Move).

% Efetua um move no Board com verificação de jogada válida
move(Board-ColoursWon, Move, NewBoard-_) :-
    checkValidPlay(Board-ColoursWon, Move),
    updateBoard(Board, Move, NewBoard).

% Verifica se um jogador ganhou o jogo
checkPlayerWinner(Purple-Orange-_) :-
    Purple == 'TRUE', Orange == 'TRUE'.

checkPlayerWinner(Purple-_-Green) :-
    Purple == 'TRUE', Green == 'TRUE'.

checkPlayerWinner(_-Orange-Green) :-
    Orange == 'TRUE', Green == 'TRUE'.

% Verifica a situação de Game Over
game_over(Colours1-_, Winner) :-
    checkPlayerWinner(Colours1),
    Winner is 1.

game_over(_-Colours2, Winner) :-
    checkPlayerWinner(Colours2),
    Winner is 2.

% Verifica se uma cor já foi ganha por algum player
checkColours(_, _, _, 'TRUE', _, 'TRUE').

checkColours(_, _, _, 'FALSE', 'TRUE', 'FALSE').

checkColours(Board, Colour, Player, 'FALSE', 'FALSE', NewColour) :-
    checkColourWon(Board, Player, Colour, ColourWon),
    NewColour = ColourWon.

% Ciclo principal do jogo (Jogada dos dois players com verificações de cores ganhas; término de jogo e displays de informação)
gameLoop(Board-(PurpleWon1-OrangeWon1-GreenWon1-PurpleWon2-OrangeWon2-GreenWon2), P1-_, 1) :-
    % Player 1   
    display_game(Board-(PurpleWon1-OrangeWon1-GreenWon1-PurpleWon2-OrangeWon2-GreenWon2), 1),
    userPlay(Board-(PurpleWon1-OrangeWon1-GreenWon1-PurpleWon2-OrangeWon2-GreenWon2), NewBoard-_, 1-P1),
    checkColours(NewBoard, purple, 1, PurpleWon1, PurpleWon2, NewPurpleWon1),
    checkColours(NewBoard, orange, 1, OrangeWon1, OrangeWon2, NewOrangeWon1),
    checkColours(NewBoard, green, 1, GreenWon1, GreenWon2, NewGreenWon1),
    checkColours(NewBoard, purple, 2, PurpleWon2, NewPurpleWon1, NewPurpleWon2),
    checkColours(NewBoard, orange, 2, OrangeWon2, NewOrangeWon1, NewOrangeWon2),
    checkColours(NewBoard, green, 2, GreenWon2, NewGreenWon1, NewGreenWon2),
    
    displayColoursState(1, NewPurpleWon1-NewOrangeWon1-NewGreenWon1),
    displayColoursState(2, NewPurpleWon2-NewOrangeWon2-NewGreenWon2),

    game_over((NewPurpleWon1-NewOrangeWon1-NewGreenWon1)-(NewPurpleWon2-NewOrangeWon2-NewGreenWon2), Winner),
    display_game(NewBoard-(NewPurpleWon1-NewOrangeWon1-NewGreenWon1-NewPurpleWon2-NewOrangeWon2-NewGreenWon2), 0),
    write('Player '), write(Winner), write(' won!'), nl.

gameLoop(NewBoard-(NewPurpleWon1-NewOrangeWon1-NewGreenWon1-NewPurpleWon2-NewOrangeWon2-NewGreenWon2), _-P2, 2) :-

    % Player 2
    display_game(NewBoard-(NewPurpleWon1-NewOrangeWon1-NewGreenWon1-NewPurpleWon2-NewOrangeWon2-NewGreenWon2), 2),
    userPlay(NewBoard-(NewPurpleWon1-NewOrangeWon1-NewGreenWon1-NewPurpleWon2-NewOrangeWon2-NewGreenWon2), FinalBoard-_, 2-P2),

    checkColours(FinalBoard, purple, 2, NewPurpleWon2, NewPurpleWon1, NewPurpleWon4),
    checkColours(FinalBoard, orange, 2, NewOrangeWon2, NewOrangeWon1, NewOrangeWon4),
    checkColours(FinalBoard, green, 2, NewGreenWon2, NewGreenWon1, NewGreenWon4),
    checkColours(FinalBoard, purple, 1, NewPurpleWon1, NewPurpleWon4, NewPurpleWon3),
    checkColours(FinalBoard, orange, 1, NewOrangeWon1, NewOrangeWon4, NewOrangeWon3),
    checkColours(FinalBoard, green, 1, NewGreenWon1, NewGreenWon4, NewGreenWon3),

    displayColoursState(1, NewPurpleWon3-NewOrangeWon3-NewGreenWon3),
    displayColoursState(2, NewPurpleWon4-NewOrangeWon4-NewGreenWon4),

    game_over((NewPurpleWon3-NewOrangeWon3-NewGreenWon3)-(NewPurpleWon4-NewOrangeWon4-NewGreenWon4), Winner),
    display_game(FinalBoard-(NewPurpleWon3-NewOrangeWon3-NewGreenWon3-NewPurpleWon4-NewOrangeWon4-NewGreenWon4), 0),
    write('Player '), write(Winner), write(' won!'), nl.
             
gameLoop(FinalBoard-(NewPurpleWon3-NewOrangeWon3-NewGreenWon3-NewPurpleWon4-NewOrangeWon4-NewGreenWon4), P1-P2, _) :-
    gameLoop(FinalBoard-(NewPurpleWon3-NewOrangeWon3-NewGreenWon3-NewPurpleWon4-NewOrangeWon4-NewGreenWon4), P1-P2, 1).    


% Verifica se uma determinada Colour foi ganha pelo Player
checkColourWon(Board, Player, Colour, ColourWon) :-
    colourTable(Player, Colour-AlliedColour-NotAlliedColour),
    colourEdges(Colour, Edge1, Edge2),
    auxCheckColourWon(Board, AlliedColour-NotAlliedColour, Edge1-Edge2, ColourWon).

auxCheckColourWon(Board, AlliedColour-NotAlliedColour, Edge1-Edge2, 'TRUE') :-
    findall(Row-Diagonal, execute(Edge1, [Row, Diagonal]), StartPoints),
    colourWonOrFence(StartPoints, AlliedColour, NotAlliedColour, 0, 0, Board, Edge2), !.

auxCheckColourWon(_, _, _, 'FALSE').    

colourWonOrFence(StartPoints, _, NotAlliedColour, Depth, DistanciaAtual, Board, Edge2) :-
    once( newGetDistance(StartPoints, [], NotAlliedColour, Depth, DistanciaAtual, Result, Board, Edge2) ),
    Result == 0.

colourWonOrFence(StartPoints, AlliedColour, _, _, DistanciaAtual, Board, Edge2) :-
    max_depth(MaxDepth),
    once( newGetDistance(StartPoints, [], AlliedColour, MaxDepth, DistanciaAtual, Result, Board, Edge2) ),
    Result == 3000.



% Current Player | Other Player
other_player(1, 2).
other_player(2, 1).

% Dado um Board, unifica em Value o seu valor, sendo depois o mesmo utilizado para definir a melhor jogada no momento
value(Board-ColoursWon, Player, Value) :-
    findall(Colour1-AlliedColour1-NotAlliedColour1, colourTable(Player, Colour1-AlliedColour1-NotAlliedColour1), ColourTables),
    findall(ValueColour, ( member(Colour2-_-NotAlliedColour2, ColourTables), 
        evaluateColour(Board-ColoursWon, Colour2-NotAlliedColour2, ValueColour) ), 
        ValueColours),
    sumlist(ValueColours, Value).
    
% Avalia a distância a uma determinada Colour, unificando ValueColour
evaluateColour(Board-ColoursWon, Colour-NotAlliedColour, ValueColour) :-
    getDistanceColour(Board-ColoursWon, Colour-NotAlliedColour, Distance),
    evaluateColourDistance(Distance, ValueColour), !.

evaluateColourDistance(Distance, ValueColour) :-
    Distance is 2000,
    ValueColour is 0.

evaluateColourDistance(Distance, ValueColour) :-
    NewDistance is Distance + 1,
    ValueColour is 1 / (NewDistance ** 2).

% Verifica se uma cor já foi ou não ganha; se não então computa a distância que o jogador demora para a encontrar.
getDistanceColour(Board-ColourState, Colour-NotAlliedColour, Distance) :-
    !,    
    getColourStartingPoints(Colour, ColourState, StartPoints, Predicate),
    max_depth(MaxDepth),
    newGetDistance(StartPoints, [], NotAlliedColour, MaxDepth, 0, Distance, Board, Predicate).

getDistanceColour(_, _, 2000). % No caso de não haver caminho de uma borda à outra (cor bloqueada) a distância é avaliada em 2000

getColourStartingPoints(orange, _-'FALSE'-_, StartPoints, orange2) :-
    findall(Row-Diagonal, orange1(Row, Diagonal), StartPoints).

getColourStartingPoints(purple, 'FALSE'-_-_, StartPoints, purple2) :-
    findall(Row-Diagonal, orange1(Row, Diagonal), StartPoints).
    
getColourStartingPoints(green, _-_-'FALSE', StartPoints, green2) :-
    findall(Row-Diagonal, green1(Row, Diagonal), StartPoints).