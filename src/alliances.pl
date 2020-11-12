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

gameLoop(Board) :-
    % Player 1
    display_game(Board, 1),
    userPlay(Board, NewBoard),
    (
        (   
            checkPurpleWon(NewBoard, 1, PurpleWon), checkOrangeWon(NewBoard, 1, OrangeWon), checkGreenWon(NewBoard, 1, GreenWon),
            gameWon(PurpleWon, OrangeWon, GreenWon),
            write('\nP1 won!\n')
        );
        (
            % Player 2
            display_game(NewBoard, 2),
            userPlay(NewBoard, FinalBoard),
            (
                (
                    checkPurpleWon(FinalBoard, 2, PurpleWon), checkOrangeWon(FinalBoard, 2, OrangeWon), checkGreenWon(FinalBoard, 2, GreenWon),
                    gameWon(PurpleWon, OrangeWon, GreenWon),
                    write('\nP2 won!\n')
                );

                (
                    gameLoop(FinalBoard)
                )
            )
        )
    ).

checkPurpleWon(Board, Player, PurpleWon) :-
    (
        (
            Player == 1,
            NotAlliedPurple = green
        );
        (
            Player == 2,
            NotAlliedPurple = orange
        )
    ),
    (
        (
            purple1(Row, Diagonal),
            runPath(Row, Diagonal, Board, NotAlliedPurple, [], purple2),
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
            NotAlliedOrange = purple
        );
        (
            Player == 2,
            NotAlliedOrange = green
        )
    ),
    (
        (
            orange1(Row, Diagonal),
            runPath(Row, Diagonal, Board, NotAlliedOrange, [], orange2),
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
            NotAlliedGreen = orange
        );
        (
            Player == 2,
            NotAlliedGreen = purple
        )
    ),
    (
        (
            green1(Row, Diagonal),
            runPath(Row, Diagonal, Board, NotAlliedGreen, [], green2),
            !, displayColourWon(Player, 'GREEN'), GreenWon = 'TRUE'
        );
        (
            !, true
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