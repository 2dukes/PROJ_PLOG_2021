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
    write(Colour), nl.

checkColourWon(PurpleWon, OrangeWon, GreenWon) :-
    write(PurpleWon), write(OrangeWon), write(GreenWon),
    (
        PurpleWon == 'TRUE', displayColourWon(Player, 'PURPLE')
    );
    (   
        GreenWon == 'TRUE', displayColourWon(Player, 'GREEN')
    );
    (
        OrangeWon == 'TRUE', displayColourWon(Player, 'ORANGE')
    ).

gameWon(PurpleWon, OrangeWon, GreenWon) :-
    (PurpleWon == 'TRUE', OrangeWon == 'TRUE');
    (PurpleWon == 'TRUE', GreenWon == 'TRUE');
    (OrangeWon == 'TRUE', GreenWon == 'TRUE').

gameLoop(Board) :-
    % Player 1
    display_game(Board, 1),
    userPlay(Board, NewBoard),
    (
        (   
            checkGameEnded(NewBoard, 1, PurpleWon, OrangeWon, GreenWon),
            gameWon(PurpleWon, OrangeWon, GreenWon),
            write('\nP1 won!\n')
        );
        (
            checkColourWon(PurpleWon, OrangeWon, GreenWon), fail % Only 1 Colour Won
        );
        (
            % Player 2
            display_game(NewBoard, 2),
            userPlay(NewBoard, FinalBoard),
            (
                (
                    checkGameEnded(FinalBoard, 2, PurpleWon, OrangeWon, GreenWon), 
                    gameWon(PurpleWon, OrangeWon, GreenWon),
                    write('\nP2 won!\n')
                );
                (  
                    checkColourWon(PurpleWon, OrangeWon, GreenWon), fail % Only 1 Colour Won
                );
                (
                    gameLoop(FinalBoard)
                )
            )
        )
    ).

checkGameEnded(Board, Player, PurpleWon, OrangeWon, GreenWon) :-
    % NotAlliedPurple = green,
    % Row = 3,
    % Diagonal = 1,
    % runPath(Row, Diagonal, Board, NotAlliedPurple, [], purple1).
    (
        (
            Player == 1,
            NotAlliedPurple = green,
            NotAlliedOrange = purple,
            NotAlliedGreen = orange
        );
        (
            Player == 2,
            NotAlliedPurple = orange,
            NotAlliedOrange = green,
            NotAlliedGreen = purple
        )
    ),
    (
        (
            once(
                    ( % win purple
                        purple1(Row, Diagonal),
                        runPath(Row, Diagonal, Board, NotAlliedPurple, [], purple2),
                        PurpleWon = 'TRUE', write('YES!')
                    )
            ),
            once(
                    ( % win orange
                        orange1(Row1, Diagonal1),
                        runPath(Row1, Diagonal1, Board, NotAlliedOrange, [], orange2),
                        OrangeWon = 'TRUE'
                    )
            )
        );
        (
            (
                (
                    OrangeWon == 'TRUE', 
                );
                once(
                        ( % win orange
                            orange1(Row2, Diagonal2),
                            runPath(Row2, Diagonal2, Board, NotAlliedOrange, [], orange2),
                            OrangeWon = 'TRUE'
                        )
                )
            ),
            once(
                    ( % win green
                        green1(Row3, Diagonal3),
                        runPath(Row3, Diagonal3, Board, NotAlliedGreen, [], green2),
                        GreenWon = 'TRUE'
                    )
            )
        );
        (
            once(
                    ( % win green
                        green1(Row4, Diagonal4),
                        runPath(Row4, Diagonal4, Board, NotAlliedGreen, [], green2),
                        GreenWon = 'TRUE'
                    )
            ),
            (
                (
                    PurpleWon == 'TRUE'
                );
                once(
                        
                        ( % win purple
                            purple1(Row5, Diagonal5),
                            runPath(Row5, Diagonal5, Board, NotAlliedPurple, [], purple2),
                            PurpleWon = 'TRUE'
                        )
                )
            )
        )
    ).


play :-
    initial(GameState),
    gameLoop(GameState).

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