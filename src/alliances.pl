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
    %NewPlayer is (Player + 1) mod 2,
    print_board(GameState, 1),
    % display_discs,
    display_player(Player).


display_player(Player) :-
    write('Player '),
    NewPlayer is ((Player mod 2) + 1), 
    write(NewPlayer),
    write(' is next'), nl, nl.

gameLoop(Board) :-
    % Player 1
    userPlay(Board, NewBoard),
    display_game(NewBoard, 1),
    (
        (
            fail % checkGameEnded(), write('\nThanks for playing!\n')
        );
        (
            % Player 2
            userPlay(NewBoard, FinalBoard),
            display_game(FinalBoard, 2),
            (
                (
                    fail % checkGameEnded(), write('\nThanks for playing!\n')
                );
                (
                    gameLoop(FinalBoard)
                )
            )
        )
    ).

play :-
    initial(GameState),
    gameLoop(GameState).


% display_discs :-
%     orange(O), green(G), purple(P),
%     write('Orange discs: '), write(O), nl,
%     write('Green discs: '), write(G), nl,
%     write('Purple discs: '), write(P), nl.

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