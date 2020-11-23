:- use_module(library(lists)).
:- use_module(library(random)).
:- consult('board.pl').
:- consult('input.pl').
:- consult('utils.pl').
:- consult('bot.pl').
:- consult('game.pl').
:- consult('menus.pl').


checkValidPlay(Board, [Row, Diagonal, Colour]) :-
    (
        (
            checkEmpty([Row, Diagonal, Colour], Board)
        ); 
        (
            write('Cell not empty!'), nl, fail
        )
    ),
    (
        (
            checkAvailableDisc(Board, Colour)
        ); 
        (
            write('No more '), write(Colour), write(' discs remaining!'), nl, !, fail
        )
    ).

checkAvailableDisc(Board, Colour) :-
    countDiscs(Board, O, G, P),
    (
        (
            Colour == orange,
            NewO is 42 - O,
            NewO > 0
        );
        (
            Colour == green,
            NewG is 42 - G,
            NewG > 0
        );
        (
            Colour == purple,
            NewP is 42 - P,
            NewP > 0
        )
    ).
    
print_move([Row, Diagonal, Colour]) :-
    write('Played R:'), write(Row),
    write(', D:'), write(Diagonal),
    write(', '), write(Colour), nl.

userPlay(GameState, NewGameState, _-p) :-
    repeat,
    (
        getUserInput(Row, Diagonal, Colour),
        move(GameState, [Row, Diagonal, Colour], NewGameState)
        %print_move([Row, Diagonal, Colour])
    ).

userPlay(GameState, NewGameState, Nplayer-(c-Level)) :-
    choose_move(GameState, Nplayer, Level, Move),
    move(GameState, Move, NewGameState),
    print_move(Move).

move(Board-_, Move, NewBoard-_) :-
    checkValidPlay(Board, Move),
    updateBoard(Board, Move, NewBoard).

display_game(GameState, 0) :-
    print_board(GameState, 1),
    display_discs(GameState).

display_game(GameState, Player) :- % Switch Player every time we end printing the board.
    %, ,
    print_board(GameState, 1),
    display_discs(GameState),
    display_player(Player).

display_discs(Board) :-
    countDiscs(Board, O, G, P),
    NewO is 42 - O,
    NewG is 42 - G,
    NewP is 42 - P,
    write('   Orange discs: '), write(NewO), 
    write(' | Green discs: '), write(NewG),
    write(' | Purple discs: '), write(NewP),nl.


display_player(Player) :-
    write('Player '),
    write(Player),
    write(' turn'), nl, nl.

displayColoursState(Player, 'FALSE'-'FALSE'-'FALSE') :- write('Player '), write(Player), write(' has no colours'),nl.

displayColoursState(Player, PurpleWon-OrangeWon-GreenWon) :-
    write('Player '), write(Player), write(' has colour(s): '), 
    displayColourWon('PURPLE', PurpleWon),
    displayColourWon('ORANGE', OrangeWon),
    displayColourWon('GREEN', GreenWon),
    nl, nl.

displayColourWon(_, 'FALSE').

displayColourWon(Colour, 'TRUE') :-
    write(Colour), write(' ').


checkPlayerWinner(Purple-Orange-_) :-
    Purple == 'TRUE', Orange == 'TRUE'.

checkPlayerWinner(Purple-_-Green) :-
    Purple == 'TRUE', Green == 'TRUE'.

checkPlayerWinner(_-Orange-Green) :-
    Orange == 'TRUE', Green == 'TRUE'.


game_over(Colours1-_, Winner) :-
    checkPlayerWinner(Colours1),
    Winner is 1.

game_over(_-Colours2, Winner) :-
    checkPlayerWinner(Colours2),
    Winner is 2.

% checkColours(Colour, Player, ColourPlayer, ColourOther, NewColour)

checkColours(_, _, _, 'TRUE', _, NewColour) :-
    NewColour = 'TRUE'.

checkColours(_, _, _, ColourPlayer, 'TRUE', NewColour) :-
    NewColour = ColourPlayer.

checkColours(Board, Colour, Player, ColourPlayer, _, NewColour) :-
    checkColourWon(Board, 1, purple, ColourWon),
    NewColour = ColourWon.



gameLoop(Board-(PurpleWon1-GreenWon1-OrangeWon1-PurpleWon2-GreenWon2-OrangeWon2), P1-P2) :-
    % Player 1                                                                                    
    display_game(Board, 1),
    userPlay(Board-_, NewBoard-_, 1-P1),
    (
        (     
            write(PurpleWon1), write(PurpleWon1), write(OrangeWon1),nl,
            % checkColours(NewBoard, purple, 1, PurpleWon1, PurpleWon2, NewPurpleWon1),
            % checkColours(NewBoard, orange, 1, OrangeWon1, OrangeWon2, NewOrangeWon1),
            % checkColours(NewBoard, green, 1, GreenWon1, GreenWon2, NewGreenWon1),
            % checkColours(NewBoard, purple, 2, PurpleWon2, NewPurpleWon1, NewPurpleWon2),
            % checkColours(NewBoard, orange, 2, OrangeWon2, NewOrangeWon1, NewOrangeWon2),
            % checkColours(NewBoard, green, 2, GreenWon2, NewGreenWon1, NewGreenWon2),
            (
                ((PurpleWon1 == 'TRUE'; PurpleWon2 == 'TRUE'), (NewPurpleWon1 = PurpleWon1));
                checkColourWon(NewBoard, 1, purple, NewPurpleWon1)
            ), 
            (
                ((OrangeWon1 == 'TRUE'; OrangeWon2 == 'TRUE'), (NewOrangeWon1 = OrangeWon1));
                checkColourWon(NewBoard, 1, orange, NewOrangeWon1)
            ),
            (
                ((GreenWon1 == 'TRUE'; GreenWon2 == 'TRUE') , (NewGreenWon1 = GreenWon1));
                checkColourWon(NewBoard, 1, green, NewGreenWon1)
            ),
            (
                ((PurpleWon2 == 'TRUE'; NewPurpleWon1 == 'TRUE'), (NewPurpleWon2 = PurpleWon2));
                checkColourWon(NewBoard, 2, purple, NewPurpleWon2)
            ),
            ( 
                ((OrangeWon2 == 'TRUE'; NewOrangeWon1 == 'TRUE'), (NewOrangeWon2 = OrangeWon2));
                checkColourWon(NewBoard, 2, orange, NewOrangeWon2)
            ),
            ( 
                ((GreenWon2 == 'TRUE'; NewGreenWon1 == 'TRUE'), (NewGreenWon2 = GreenWon2));
                checkColourWon(NewBoard, 2, green, NewGreenWon2)
            ),
            
            displayColoursState(1, NewPurpleWon1-NewOrangeWon1-NewGreenWon1),
            displayColoursState(2, NewPurpleWon2-NewOrangeWon2-NewGreenWon2),
            (       
                (
                    game_over((NewPurpleWon1-NewOrangeWon1-NewGreenWon1)-(NewPurpleWon2-NewOrangeWon2-NewGreenWon2), Winner),
                    display_game(NewBoard, 0),
                    write('Player '), write(Winner), write(' won!'), nl  
                );
                (
                    % Player 2
                    display_game(NewBoard, 2),
                    userPlay(NewBoard-_, FinalBoard-_, 2-P2),
                    (
                        (
                            % checkColours(FinalBoard, purple, 2, NewPurpleWon2, NewPurpleWon1, NewPurpleWon4),
                            % checkColours(FinalBoard, orange, 2, NewOrangeWon2, NewOrangeWon1, NewOrangeWon4),
                            % checkColours(FinalBoard, green, 2, NewGreenWon2, NewGreenWon1, NewGreenWon4),
                            % checkColours(FinalBoard, purple, 1, NewPurpleWon1, NewPurpleWon4, NewPurpleWon3),
                            % checkColours(FinalBoard, orange, 1, NewOrangeWon1, NewOrangeWon4, NewOrangeWon3),
                            % checkColours(FinalBoard, green, 1, NewGreenWon1, NewGreenWon4, NewGreenWon3),
                            (
                                ((NewPurpleWon2 == 'TRUE'; NewPurpleWon1 == 'TRUE'), (NewPurpleWon4 = NewPurpleWon2));
                                checkColourWon(FinalBoard, 2, purple, NewPurpleWon4)
                            ),
                            ( 
                                ((NewOrangeWon2 == 'TRUE'; NewOrangeWon1 == 'TRUE'), (NewOrangeWon4 = NewOrangeWon2));
                                checkColourWon(FinalBoard, 2, orange, NewOrangeWon4)
                                
                            ),
                            ( 
                                ((NewGreenWon2 == 'TRUE'; NewGreenWon1 == 'TRUE'), (NewGreenWon4 = NewGreenWon2));
                                checkColourWon(FinalBoard, 2, green, NewGreenWon4)
                            ),
                            (
                                ((NewPurpleWon1 == 'TRUE'; NewPurpleWon4 == 'TRUE'), (NewPurpleWon3 = NewPurpleWon1));
                                checkColourWon(FinalBoard, 1, purple, NewPurpleWon3)
                            ), 
                            (
                                ((NewOrangeWon1 == 'TRUE'; NewOrangeWon4 == 'TRUE'), (NewOrangeWon3 = NewOrangeWon1));
                                checkColourWon(FinalBoard, 1, orange, NewOrangeWon3)
                            ),
                            (
                                ((NewGreenWon1 == 'TRUE'; NewGreenWon4 == 'TRUE') , (NewGreenWon3 = NewGreenWon1));
                                checkColourWon(FinalBoard, 1, green, NewGreenWon3)
                            ),

                            displayColoursState(1, NewPurpleWon3-NewOrangeWon3-NewGreenWon3),
                            displayColoursState(2, NewPurpleWon4-NewOrangeWon4-NewGreenWon4),
                            (
                                (
                                    game_over((NewPurpleWon3-NewOrangeWon3-NewGreenWon3)-(NewPurpleWon4-NewOrangeWon4-NewGreenWon4), Winner),
                                    display_game(FinalBoard, 0),
                                    write('Player '), write(Winner), write(' won!'), nl  
                                    
                                );
                                gameLoop(FinalBoard-(NewPurpleWon3-NewGreenWon3-NewOrangeWon3-NewPurpleWon4-NewGreenWon4-NewOrangeWon4), P1-P2)
                            )
                        )
                    )
                )
            )
        )
    ).

checkColourWon(Board, Player, Colour, ColourWon) :-
    colourTable(Player, Colour-AlliedColour-NotAlliedColour),
    colourEdges(Colour, Edge1, Edge2),
    (
        (
            (
                (
                    execute(Edge1, [Row, Diagonal]),
                    getDistance(Row-Diagonal, Board, NotAlliedColour, [], Edge2, 'FALSE', 0, 0, Result),
                    Result == 0
                );
                (
                    findall(Row-Diagonal, execute(Edge1, [Row, Diagonal]), [P1,P2,P3,P4,P5]),
                    checkBlocked(P1, Board, AlliedColour, [], _, Edge2),
                    checkBlocked(P2, Board, AlliedColour, [], _, Edge2),
                    checkBlocked(P3, Board, AlliedColour, [], _, Edge2),
                    checkBlocked(P4, Board, AlliedColour, [], _, Edge2),
                    checkBlocked(P5, Board, AlliedColour, [], _, Edge2)
                )
            ),
            !, ColourWon = 'TRUE'
        );
        (
            !, ColourWon = 'FALSE'
        )
    ).

startGame(GameState) :-
    mainMenu(GameState).

play :-
    initial(GameState),
    startGame(GameState).
