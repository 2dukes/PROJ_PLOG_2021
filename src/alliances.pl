:- use_module(library(lists)).
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
    


userPlay(Board, NewBoard) :-
    repeat,
    (
        getUserInput(Row, Diagonal, Colour),
        move(Board, [Row, Diagonal, Colour], NewBoard)
    ).
    
    % move(+GameState, +Move, -NewGameState)

move(Board, Move, NewBoard) :-
    checkValidPlay(Board, Move),
    updateBoard(Board, Move, NewBoard).


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
    write('Orange discs: '), write(NewO), nl,
    write('Green discs: '), write(NewG), nl,
    write('Purple discs: '), write(NewP), nl.


display_player(Player) :-
    write('Player '),
    write(Player),
    write(' turn'), nl, nl.

displayColourWon(Player, PurpleWon-OrangeWon-GreenWon) :-
    (
        (PurpleWon == 'TRUE'; OrangeWon == 'TRUE'; GreenWon == 'TRUE'),
        write('Player '), write(Player), write(' has colour(s): '), 
        (
            (PurpleWon == 'TRUE', write('PURPLE ')); true
        ),
        (
            (OrangeWon == 'TRUE', write('ORANGE ')); true
        ),
        (
            (GreenWon == 'TRUE', write('GREEN ')); true
        ), nl, nl
    ); true.


game_over([[PurpleWon1, GreenWon1, OrangeWon1], [PurpleWon2, GreenWon2, OrangeWon2]], Winner) :-
    (
        (
            (PurpleWon1 == 'TRUE', OrangeWon1 == 'TRUE');
            (PurpleWon1 == 'TRUE', GreenWon1 == 'TRUE');
            (OrangeWon1 == 'TRUE', GreenWon1 == 'TRUE')
        ),
        Winner is 1
    );
    (
        (   
            (PurpleWon2 == 'TRUE', OrangeWon2 == 'TRUE');
            (PurpleWon2 == 'TRUE', GreenWon2 == 'TRUE');
            (OrangeWon2 == 'TRUE', GreenWon2 == 'TRUE')
        ),
        Winner is 2
    ).

gameLoop(Board-(PurpleWon1-GreenWon1-OrangeWon1-PurpleWon2-GreenWon2-OrangeWon2)) :-
    % Player 1
    display_game(Board, 1),
    userPlay(Board, NewBoard),
    (
        (   
            
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
            (       
                (
                    displayColourWon(1, NewPurpleWon1-NewOrangeWon1-NewGreenWon1),
                    displayColourWon(2, NewPurpleWon2-NewOrangeWon2-NewGreenWon2),
                    (  
                        game_over([[NewPurpleWon1, NewOrangeWon1, NewGreenWon1],[NewPurpleWon2, NewOrangeWon2, NewGreenWon2]], Winner),
                        write('Player '), write(Winner), write(' won!'), nl  
                    )
                );
                (
                    % Player 2
                    display_game(NewBoard, 2),
                    userPlay(NewBoard, FinalBoard),
                    (
                        (
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
                            (
                                (
                                    displayColourWon(1, NewPurpleWon3-NewOrangeWon3-NewGreenWon3),
                                    displayColourWon(2, NewPurpleWon4-NewOrangeWon4-NewGreenWon4),
                                    (  
                                        game_over([[NewPurpleWon3, NewOrangeWon3, NewGreenWon3],[NewPurpleWon4, NewOrangeWon4, NewGreenWon4]], Winner),
                                        write('Player '), write(Winner), write(' won!'), nl  
                                    )
                                );
                                gameLoop(FinalBoard-(NewPurpleWon3-NewGreenWon3-NewOrangeWon3-NewPurpleWon4-NewGreenWon4-NewOrangeWon4))
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
                    runPath(Row, Diagonal, Board, NotAlliedColour, [], Edge2)
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
            !, true
        )
    ).

startGame(GameState) :-
    mainMenu(GameState).

play :-
    initial(GameState),
    startGame(GameState).
