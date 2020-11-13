:- consult('board.pl').
:- consult('input.pl').
:- consult('utils.pl').


checkValidPlay(Board, [Row, Diagonal, Colour]) :-
    (
        (
            checkEmpty(Row, Diagonal, Board)
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
    print_board(GameState, 1),
    display_discs(GameState),
    display_player(Player).


countDiscs([], 0, 0, 0).
countDiscs([Line | Rest], OrangeDiscs, GreenDiscs, PurpleDiscs) :-
    countOccurrence(Line, orange, AuxOrangeDiscs),
    countOccurrence(Line, green, AuxGreenDiscs),
    countOccurrence(Line, purple, AuxPurpleDiscs),
    countDiscs(Rest, Oranges, Greens, Purples),
    OrangeDiscs is Oranges + AuxOrangeDiscs,
    GreenDiscs is Greens + AuxGreenDiscs,
    PurpleDiscs is Purples + AuxPurpleDiscs.

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

displayColourWon(Player, Colour) :-
    write('Player '), write(Player), write(' has colour '),
    write(Colour), nl, nl.

gameWon(PurpleWon, OrangeWon, GreenWon) :-
    (PurpleWon == 'TRUE', OrangeWon == 'TRUE');
    (PurpleWon == 'TRUE', GreenWon == 'TRUE');
    (OrangeWon == 'TRUE', GreenWon == 'TRUE').

gameLoop(Board, [[PurpleWon1, GreenWon1, OrangeWon1], [PurpleWon2, GreenWon2, OrangeWon2]]) :-
    % Player 1
    display_game(Board, 1),
    userPlay(Board, NewBoard),
    (
        (   
            (
                ((PurpleWon1 == 'TRUE'; PurpleWon2 == 'TRUE'), (NewPurpleWon1 = PurpleWon1));
                checkPurpleWon(NewBoard, 1, NewPurpleWon1)
            ), 
            (
                ((OrangeWon1 == 'TRUE'; OrangeWon2 == 'TRUE'), (NewOrangeWon1 = OrangeWon1));
                checkOrangeWon(NewBoard, 1, NewOrangeWon1)
            ),
            (
                ((GreenWon1 == 'TRUE'; GreenWon2 == 'TRUE') , (NewGreenWon1 = GreenWon1));
                checkGreenWon(NewBoard, 1, NewGreenWon1)
            ),
            (       
                (
                    gameWon(NewPurpleWon1, NewOrangeWon1, NewGreenWon1),
                    write('\nP1 won!\n')
                );
                (
                    % Player 2
                    display_game(NewBoard, 2),
                    userPlay(NewBoard, FinalBoard),
                    (
                        (
                            (
                                ((PurpleWon2 == 'TRUE'; NewPurpleWon1 == 'TRUE'), (NewPurpleWon2 = PurpleWon2));
                                checkPurpleWon(FinalBoard, 2, NewPurpleWon2)
                            ),
                            ( 
                                ((OrangeWon2 == 'TRUE'; NewOrangeWon1 == 'TRUE'), (NewOrangeWon2 = OrangeWon2));
                                checkOrangeWon(FinalBoard, 2, NewOrangeWon2)
                            ),
                            ( 
                                ((GreenWon2 == 'TRUE'; NewGreenWon1 == 'TRUE'), (NewGreenWon2 = GreenWon2));
                                checkGreenWon(FinalBoard, 2, NewGreenWon2)
                            ),
                            (
                                (
                                    gameWon(NewPurpleWon2, NewOrangeWon2, NewGreenWon2),
                                    write('\nP2 won!\n')
                                );
                                gameLoop(FinalBoard, [[NewPurpleWon1, NewGreenWon1, NewOrangeWon1], [NewPurpleWon2, NewGreenWon2, NewOrangeWon2]])
                            )
                        )
                    )
                )
            )
        )
    ).

checkPurpleWon(Board, Player, PurpleWon) :-
    (
        (
            Player == 1,
            AlliedColour = orange,
            NotAlliedPurple = green
        );
        (
            Player == 2,
            AlliedColour = green,
            NotAlliedPurple = orange
        )
    ),
    (
        (
            (
                (
                    purple1(Row, Diagonal),
                    %write('Finding purple path'),nl,
                    runPath(Row, Diagonal, Board, NotAlliedPurple, [], purple2)
                ); 
                (
                    %write('checkNotBlocked1'),nl,
                    %\+ checkNotBlocked(Row, Diagonal, Board, AlliedColour, [], purple2,0)
                    checkBlocked(1, 1, Board, AlliedColour, [], _, purple2),
                    checkBlocked(2, 1, Board, AlliedColour, [], _, purple2),
                    checkBlocked(3, 1, Board, AlliedColour, [], _, purple2),
                    checkBlocked(4, 1, Board, AlliedColour, [], _, purple2),
                    checkBlocked(5, 1, Board, AlliedColour, [], _, purple2)
                )
            ),
            !, displayColourWon(Player, 'PURPLE'), PurpleWon = 'TRUE'
        );
        (
            !, true
        )
    ).

checkOrangeWon(Board, Player, OrangeWon) :-
    ( 
        (
            Player == 1,
            AlliedColour = green,
            NotAlliedOrange = purple
        );
        (
            Player == 2,
            AlliedColour = purple,
            NotAlliedOrange = green
        )
    ),
    (
        (
            (
                (
                    orange1(Row, Diagonal),
                    runPath(Row, Diagonal, Board, NotAlliedOrange, [], orange2)
                );
                (
                    %write('checkNotBlocked2'), nl,
                    
                    % \+ (checkNotBlocked(Row, Diagonal, Board, AlliedColour, [], orange2); ...)
                    %\+ checkNotBlocked(Row, Diagonal, Board, AlliedColour, [], orange2,0)
                    checkBlocked(8, 2, Board, AlliedColour, [], _, orange2),
                    checkBlocked(10, 3, Board, AlliedColour, [], _, orange2),
                    checkBlocked(12, 4, Board, AlliedColour, [], _, orange2),
                    checkBlocked(14, 5, Board, AlliedColour, [], _, orange2),
                    checkBlocked(16, 6, Board, AlliedColour, [], _, orange2)
                )
            ),
            !, displayColourWon(Player, 'ORANGE'), OrangeWon = 'TRUE'
        );
        (
            !, true
        )
    ).

checkGreenWon(Board, Player, GreenWon) :-
    (
        (
            Player == 1,
            AlliedColour = purple,
            NotAlliedGreen = orange
        );
        (
            Player == 2,
            AlliedColour = orange,
            NotAlliedGreen = purple
        )
    ),
    (
        (
            (
                (
                    green1(Row, Diagonal),
                    runPath(Row, Diagonal, Board, NotAlliedGreen, [], green2)
                );
                (
                    %write('checkBlockedGreen 1'),nl, 
                    %\+checkNotBlocked(Row, Diagonal, Board, AlliedColour, [], green2,0)
                    checkBlocked(19, 8, Board, AlliedColour, [], _, green2),
                    %write('checkBlockedGreen 2'),nl, 
                    checkBlocked(20, 9, Board, AlliedColour, [], _, green2),
                    %write('checkBlockedGreen 3'),nl, 
                    checkBlocked(21, 10, Board, AlliedColour, [], _, green2),
                    %write('checkBlockedGreen 4'),nl, 
                    checkBlocked(22, 11, Board, AlliedColour, [], _, green2),
                    %write('checkBlockedGreen 5'),nl, 
                    checkBlocked(23, 12, Board, AlliedColour, [], _, green2)
                    %checkBlocked(Row, Diagonal, Board, AlliedColour, [], _, green2)
                )
            ),
            !, displayColourWon(Player, 'GREEN'), GreenWon = 'TRUE'
        );
        (
            !, true
        )
    ).


play :-
    initial(GameState),
    gameLoop(GameState, [['FALSE', 'FALSE', 'FALSE'], ['FALSE', 'FALSE', 'FALSE']]).

% line_elem(N, List, Elem, Counter, Aux) :- % Returns the content(Elem) of the Nth cell in the 'List' line of the board 
%     (
%         nth0(Aux, List, Result),
%         ( 
%             (Result == empty ; Result == purple ; Result == orange ; Result == green),
%             (
%                 (
%                     Counter == N, Elem = Result
%                 );
%                 (
%                     NewCounter is Counter + 1,
%                     NewAux is Aux + 1,
%                     line_elem(N, List, Elem, NewCounter, NewAux)
%                 )
%             )
%         );
%         (
%             NewAux is Aux + 1,
%             line_elem(N, List, Elem, Counter, NewAux)
%         )
%     ).


% cell(L, C, Elem) :- % Returns the cell in a specific Line | Column
%     initial(Board),
%     nth0(L, Board, Line),
%     line_elem(C, Line, Elem, 0, 0).