:- consult('board.pl').
:- consult('input.pl').
:- consult('utils.pl').


checkValidPlay(Row, Diagonal, Board) :-
    (
        checkEmpty(Row, Diagonal, Board)
    ); 
    (
        write('Cell not empty!'), nl, fail
    ).

userPlay(Board, NewBoard) :-
    
    repeat,
    (
        getUserInput(Row, Diagonal, Colour),
        move(Board, Row, Diagonal, Colour, NewBoard)
    ).
    
    % move(+GameState, +Move, -NewGameState)

move(Board, Row, Diagonal, Colour, NewBoard) :-
    checkValidPlay(Row, Diagonal, Board),
    updateBoard(Board, Row, Diagonal, Colour, NewBoard).


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

gameLoop(Board, [PurpleWon, GreenWon, OrangeWon]) :-
    % Player 1
    display_game(Board, 1),
    userPlay(Board, NewBoard),
    (
        (   
            (
                (PurpleWon == 'TRUE', PurpleWon1 = PurpleWon);
                checkPurpleWon(NewBoard, 1, PurpleWon1)
            ), 
            (
                (OrangeWon == 'TRUE', OrangeWon1 = OrangeWon);
                checkOrangeWon(NewBoard, 1, OrangeWon1)
            ),
            (
                (GreenWon == 'TRUE', GreenWon1 = GreenWon);
                checkGreenWon(NewBoard, 1, GreenWon1)
            ),
            gameWon(PurpleWon1, OrangeWon1, GreenWon1),
            write('\nP1 won!\n')
        );
        (
            % Player 2
            display_game(NewBoard, 2),
            userPlay(NewBoard, FinalBoard),
            (
                (
                    (
                        (PurpleWon1 == 'TRUE', PurpleWon2 = PurpleWon1);
                        checkPurpleWon(FinalBoard, 2, PurpleWon2)
                    ),
                    ( 
                        (OrangeWon1 == 'TRUE', OrangeWon2 = OrangeWon1);
                        checkOrangeWon(FinalBoard, 2, OrangeWon2)
                    ),
                    ( 
                        (GreenWon1 == 'TRUE', GreenWon2 = GreenWon1);
                        checkGreenWon(FinalBoard, 2, GreenWon2)
                    ),
                    gameWon(PurpleWon2, OrangeWon2, GreenWon2),
                    write('\nP2 won!\n')
                );

                (
                    gameLoop(FinalBoard, [PurpleWon2, GreenWon2, OrangeWon2])
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
            purple1(Row, Diagonal),
            (
                runPath(Row, Diagonal, Board, NotAlliedPurple, [], purple2); 
                (
                    write('checkNotBlocked1'),nl,  
                    \+ checkNotBlocked(Row, Diagonal, Board, AlliedColour, [], purple2)
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
            orange1(Row, Diagonal),
            (
                runPath(Row, Diagonal, Board, NotAlliedOrange, [], orange2);
                (
                    write('checkNotBlocked2'), nl,
                    fail
                    % \+ (checkNotBlocked(Row, Diagonal, Board, AlliedColour, [], orange2); ...)
                    % \+ checkNotBlocked(Row, Diagonal, Board, AlliedColour, [], orange2)
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
            green1(Row, Diagonal),
            (
                write('Preso'), runPath(Row, Diagonal, Board, NotAlliedGreen, [], green2);
                (
                    write('checkNotBlocked3'),nl,
                    \+ checkNotBlocked(19, 8, Board, AlliedColour, [], green2),
                    \+ checkNotBlocked(20, 9, Board, AlliedColour, [], green2),
                    \+ checkNotBlocked(21, 10, Board, AlliedColour, [], green2),
                    \+ checkNotBlocked(22, 11, Board, AlliedColour, [], green2),
                    \+ checkNotBlocked(23, 12, Board, AlliedColour, [], green2)
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
    gameLoop(GameState, ['FALSE', 'FALSE', 'FALSE']).

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