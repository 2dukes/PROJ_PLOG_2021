:- use_module(library(lists)).
:- dynamic initial/1.
:- dynamic player/1.
:- dynamic green/1.
:- dynamic orange/1.
:- dynamic purple/1.

% Board atoms:
code(empty, ' ').
code(orange, 'O').
code(purple, 'P').
code(green, 'G').

info(1, ' [G]').
info(2, ' [G]').
info(3, ' [G]').
info(4, ' [G]').
info(5, ' [G]').
info(6, ' [G]').
info(8, '  [O]').
info(9, '  [O]').
info(10, ' [O]').
info(11, ' [O]').
info(12, ' [O]').
info(13, ' [P]').

line(1, '                            1').
line(2, '                        2').
line(3, '                    3').
line(4, '                4').
line(5, '                    5').
line(6, '                  6').
line(7, '                 7').
line(8, '          8').
line(9, '                9').
line(10, '          10').
line(11, '                11').
line(12, '          12').
line(13, '                13').
line(14, '          14').
line(15, '                15').
line(16, '          16').
line(17, '                17').
line(18, '                    18').
line(19, '                  19').
line(20, '                 20').
line(21, '                     21').
line(22, '                         22').
line(23, '                             23').







orange(42).
purple(42).
green(42).

initial([
[                                         empty,    empty],
[                                     empty,   empty,   empty],
[                                empty,    empty,   empty,  empty],
[                           empty,    empty,    empty,   empty,   empty],
[                      empty,    empty,    empty,   empty,   empty,   empty],
[                          empty,     empty,   empty,   empty,    empty],
[                      empty,    empty,    empty,   empty,   empty,   empty],
[                 empty,   empty,     empty,   empty,   empty,    empty,   empty],
[                      empty,    empty,    empty,   empty,   empty,   empty],
[                 empty,   empty,     empty,   empty,   empty,    empty,   empty],
[                      empty,    empty,    empty,   empty,   empty,   empty],
[                 empty,   empty,     empty,   empty,   empty,    empty,   empty],
[                      empty,    empty,    empty,   empty,   empty,   empty],
[                 empty,   empty,     empty,   empty,   empty,    empty,   empty],
[                      empty,    empty,    empty,   empty,   empty,   empty],
[                 empty,   empty,     empty,   empty,   empty,    empty,   empty],
[                      empty,    empty,    empty,   empty,   empty,   empty],
[                           empty,    empty,   empty,    empty,   empty],
[                      empty,    empty,    empty,   empty,   empty,   empty],
[                           empty,    empty,   empty,   empty,   empty],
[                                empty,    empty,   empty,   empty],
[                                     empty,   empty,   empty],
[                                          empty,   empty]
]).

spaces([17, 13, 9, 5, 4, 4, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 8, 12, 16]).

printLineInfo(Nline) :-
    info(Nline, Info),
    write(Info).

printLineNumber(Nline) :-
    line(Nline, Info),
    write(Info).

print_board([], _) :- 
    printSpaces(20), put_code(9586), write('___'), put_code(9585), write('   '), put_code(9586), write('___'), put_code(9585), write('[P]'), nl.
print_board([L | Board], Line) :-
    print_line(L, Line),
    NewLine is Line + 1,
    print_board(Board, NewLine).

print_line([Cell | Line], Nline) :-
    ( 
        (
            Nline == 1,
            printSpaces(21), write('___  1  ___ 2'), printLineInfo(2), nl
        );
        true
    ),
    (
        getSpaces(Spaces, Nline),
        %nth1(Nline, Spaces, E),
        printSpaces(Spaces),
        (
            (
                (
                    Nline =< 4; Nline == 7
                ),
                print_case1([Cell | Line], Nline)
            );
            (
                %member(Nline, [5, 8, 10, 12, 14, 16, 19]),
                (
                    (Nline == 5);
                    (
                        Nline >= 8,
                        Nline =< 16, 
                        Mod is mod(Nline, 2),
                        Mod == 0
                    );
                    (Nline == 19)
                ),
                print_case2([Cell | Line], 0, Nline)
            );
            (
                %member(Nline, [6, 9, 11, 13, 15, 17, 18, 20, 21, 22, 23]),
                (
                    (
                        Nline >= 17,
                        Nline \= 19
                    );
                    (Nline == 6);
                    (
                        Nline >= 9,
                        Nline =< 15,
                        Mod is mod(Nline, 2),
                        Mod == 1
                    )
                ),
                print_case3([Cell | Line], Nline)   
            )
        ),
        printLineNumber(Nline),
        nl
    ).

getSpaces(Spaces, Nline) :-
    spaces(Aux),
    nth1(Nline, Aux, Spaces).

printSpaces(0).
printSpaces(Nspaces) :-
    write(' '),
    NewNspaces is Nspaces - 1,
    printSpaces(NewNspaces).
    

print_case1([], Nline) :- 
    write('___'), 
    (
        (
            Nline =< 5,
            Diagonal is Nline + 2, 
            write(Diagonal), printLineInfo(Diagonal)
        )
    ); true.
    
print_case1([Cell | Line], Nline) :- %partes de cima
    write('___'),
    put_code(9585),
    write(' '),  
    code(Cell, P),             %  ___/ c \
    write(P),
    write(' '),
    put_code(9586),
    print_case1(Line, Nline).


print_case2([], _, Nline) :-
    (
        Nline \= 5,
        (
            Nline == 10, write('9'), printLineInfo(9)
        );
        (
            Nline == 12, write('10'), printLineInfo(10)
        );
        (
            Nline == 14, write('11'), printLineInfo(11)
        );
        (
            Nline == 16, write('12'), printLineInfo(12)
        );
        (
            Nline == 19, write('13')
        );
        (
            Nline == 8, write('8'), printLineInfo(8)
        )
    ); true.

print_case2([Cell | Line], Col, Nline) :- %parte sem lados
    (
        (
            Col == 0,
            put_code(9585),  %  / c \
            write(' '),
            code(Cell, P),
            write(P),            
            write(' '),       
            put_code(9586)    
        );
        (
            write('___'),
            put_code(9585),
            write(' '),
            code(Cell, P),     % ___/ c \
            write(P),
            write(' '),
            put_code(9586)
        )
    ),
    NewCol is Col + 1,
    print_case2(Line, NewCol, Nline).

print_case3([], Nline) :- 
    put_code(9586), 
    write('___'),
    put_code(9585),
    (
        (
            Nline == 6, 
            write(' 7')
        );
        (
            Nline >= 19,
            write('[P]')
        );
        true
    ).
print_case3([Cell | Line], Nline) :- % partes de baixo
    put_code(9586),
    write('___'),
    put_code(9585),
    write(' '),
    code(Cell, P),       %  \___/ c
    write(P),
    write(' '),
    print_case3(Line, Nline).


player(1). % First Player.

updatePlayer(Number) :- % Update the current player dinamically.
    retract(player(_)),
    assert(player(Number)).

display_game(GameState, Player) :- % Switch Player every time we end printing the board.
    NewPlayer is (Player + 1) mod 2,
    updatePlayer(NewPlayer),
    print_board(GameState, 1),
    display_discs,
    display_player(Player).

display_discs :-
    orange(O), green(G), purple(P),
    write('Orange discs: '), write(O), nl,
    write('Green discs: '), write(G), nl,
    write('Purple discs: '), write(P), nl.

display_player(Player) :-
    write('Player '), 
    write(Player),
    write(' is next').

line_elem(N, List, Elem, Counter, Aux) :- % Returns the content(Elem) of the Nth cell in the 'List' line of the board 
    (
        nth0(Aux, List, Result),
        ( 
            (Result == empty ; Result == purple ; Result == orange ; Result == green),
            (
                (
                    Counter == N, Elem = Result
                );
                (
                    NewCounter is Counter + 1,
                    NewAux is Aux + 1,
                    line_elem(N, List, Elem, NewCounter, NewAux)
                )
            )
        );
        (
            NewAux is Aux + 1,
            line_elem(N, List, Elem, Counter, NewAux)
        )
    ).


cell(L, C, Elem) :- % Returns the cell in a specific Line | Column
    initial(Board),
    nth0(L, Board, Line),
    line_elem(C, Line, Elem, 0, 0).

play :-
    initial(GameState),
    player(Player), % Assume first player.
    display_game(GameState, Player).
