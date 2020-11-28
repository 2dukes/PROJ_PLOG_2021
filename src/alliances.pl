:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(system)).
:- consult('board.pl').
:- consult('input.pl').
:- consult('utils.pl').
:- consult('bot.pl').
:- consult('game.pl').
:- consult('menus.pl').

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

% Imprime toda a informação do jogo
display_game(Board-ColoursWon, 0) :-
    print_board(Board, 1),
    display_discs(Board-ColoursWon).

display_game(Board-ColoursWon, Player) :- % Switch Player every time we end printing the board.
    print_board(Board, 1),
    display_discs(Board-ColoursWon),
    display_player(Player).

% Imprime número de discos disponíveis
display_discs(GameState) :-
    countDiscs(GameState, O, G, P),
    NewO is 42 - O,
    NewG is 42 - G,
    NewP is 42 - P,
    write('   Orange discs: '), write(NewO), 
    write(' | Green discs: '), write(NewG),
    write(' | Purple discs: '), write(NewP),nl.

% Imprime a vez do próximo Jogador
display_player(Player) :-
    write('                      Player '),
    write(Player),
    write('\'s turn'), nl, nl.

% Imprime as cores que cada jogador já arrecadou
displayColoursState(Player, 'FALSE'-'FALSE'-'FALSE') :- write('Player '), write(Player), write(' has no colours'),nl.

displayColoursState(Player, PurpleWon-OrangeWon-GreenWon) :-
    write('Player '), write(Player), write(' has colour(s): '), 
    displayColourWon('PURPLE', PurpleWon),
    displayColourWon('ORANGE', OrangeWon),
    displayColourWon('GREEN', GreenWon),
    nl, nl.

% Display de cor ganha
displayColourWon(_, 'FALSE').

displayColourWon(Colour, 'TRUE') :-
    write(Colour), write(' ').

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
gameLoop(Board-(PurpleWon1-OrangeWon1-GreenWon1-PurpleWon2-OrangeWon2-GreenWon2), P1-P2) :-
    % Player 1   
    display_game(Board-(PurpleWon1-OrangeWon1-GreenWon1-PurpleWon2-OrangeWon2-GreenWon2), 1),
    userPlay(Board-(PurpleWon1-OrangeWon1-GreenWon1-PurpleWon2-OrangeWon2-GreenWon2), NewBoard-_, 1-P1),
    (
        (     
            checkColours(NewBoard, purple, 1, PurpleWon1, PurpleWon2, NewPurpleWon1),
            checkColours(NewBoard, orange, 1, OrangeWon1, OrangeWon2, NewOrangeWon1),
            checkColours(NewBoard, green, 1, GreenWon1, GreenWon2, NewGreenWon1),
            checkColours(NewBoard, purple, 2, PurpleWon2, NewPurpleWon1, NewPurpleWon2),
            checkColours(NewBoard, orange, 2, OrangeWon2, NewOrangeWon1, NewOrangeWon2),
            checkColours(NewBoard, green, 2, GreenWon2, NewGreenWon1, NewGreenWon2),
            
            displayColoursState(1, NewPurpleWon1-NewOrangeWon1-NewGreenWon1),
            displayColoursState(2, NewPurpleWon2-NewOrangeWon2-NewGreenWon2),
            (       
                (
                    game_over((NewPurpleWon1-NewOrangeWon1-NewGreenWon1)-(NewPurpleWon2-NewOrangeWon2-NewGreenWon2), Winner),
                    display_game(NewBoard-(NewPurpleWon1-NewOrangeWon1-NewGreenWon1-NewPurpleWon2-NewOrangeWon2-NewGreenWon2), 0),
                    write('Player '), write(Winner), write(' won!'), nl  
                );
                (
                    % Player 2
                    display_game(NewBoard-(NewPurpleWon1-NewOrangeWon1-NewGreenWon1-NewPurpleWon2-NewOrangeWon2-NewGreenWon2), 2),
                    userPlay(NewBoard-(NewPurpleWon1-NewOrangeWon1-NewGreenWon1-NewPurpleWon2-NewOrangeWon2-NewGreenWon2), FinalBoard-_, 2-P2),
                    (
                        (
                            checkColours(FinalBoard, purple, 2, NewPurpleWon2, NewPurpleWon1, NewPurpleWon4),
                            checkColours(FinalBoard, orange, 2, NewOrangeWon2, NewOrangeWon1, NewOrangeWon4),
                            checkColours(FinalBoard, green, 2, NewGreenWon2, NewGreenWon1, NewGreenWon4),
                            checkColours(FinalBoard, purple, 1, NewPurpleWon1, NewPurpleWon4, NewPurpleWon3),
                            checkColours(FinalBoard, orange, 1, NewOrangeWon1, NewOrangeWon4, NewOrangeWon3),
                            checkColours(FinalBoard, green, 1, NewGreenWon1, NewGreenWon4, NewGreenWon3),

                            displayColoursState(1, NewPurpleWon3-NewOrangeWon3-NewGreenWon3),
                            displayColoursState(2, NewPurpleWon4-NewOrangeWon4-NewGreenWon4),
                            (
                                (
                                    game_over((NewPurpleWon3-NewOrangeWon3-NewGreenWon3)-(NewPurpleWon4-NewOrangeWon4-NewGreenWon4), Winner),
                                    display_game(FinalBoard-(NewPurpleWon3-NewOrangeWon3-NewGreenWon3-NewPurpleWon4-NewOrangeWon4-NewGreenWon4), 0),
                                    write('Player '), write(Winner), write(' won!'), nl  
                                );
                                gameLoop(FinalBoard-(NewPurpleWon3-NewOrangeWon3-NewGreenWon3-NewPurpleWon4-NewOrangeWon4-NewGreenWon4), P1-P2)
                            )
                        )
                    )
                )
            )
        )
    ).

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

% Start Game (Direciona para o Menu principal)
startGame(GameState) :-
    mainMenu(GameState).

% Mother predicate
play :-
    initial(GameState),
    startGame(GameState).
