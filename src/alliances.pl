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
code(nodef, '      ').
code(space, '   ').
code(purpleEnd, '  pur ').
code(greenEnd, '   grn').
code(orangeEnd, '   org').
code(purpleEndSpace, 'pur').
code(greenEndSpace, 'grn').
code(orangeEndSpace, 'org').

end(purpleEnd).
end(greenEnd).
end(orangeEnd).
end(purpleEndSpace).
end(greenEndSpace).
end(orangeEndSpace).

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

print_board([], _) :- 
    printSpaces(20), put_code(9586), write('___'), put_code(9585), write('   '), put_code(9586), write('___'), put_code(9585), nl.
print_board([L | Board], Line) :-
    print_line(L, Line),
    NewLine is Line + 1,
    print_board(Board, NewLine).


print_line([Cell | Line], Nline) :-
    ( 
        (
            Nline == 1,
            printSpaces(21), write('___     ___'), nl
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
                print_case1([Cell | Line])
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
                print_case2([Cell | Line], 0)
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
                print_case3([Cell | Line])   
            )
        ),
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
    

print_case1([]) :- write('___').
print_case1([Cell | Line]) :- %partes de cima
    write('___'),
    put_code(9585),
    write(' '),  
    code(Cell, P),             %  ___/ c \
    write(P),
    write(' '),
    put_code(9586),
    print_case1(Line).


print_case2([], _).
print_case2([Cell | Line], Col) :- %parte sem lados
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
    print_case2(Line, NewCol).

print_case3([]) :- put_code(9586), write('___'), put_code(9585).
print_case3([Cell | Line]) :- % partes de baixo
    put_code(9586),
    write('___'),
    put_code(9585),
    write(' '),
    code(Cell, P),       %  \___/ c
    write(P),
    write(' '),
    print_case3(Line).


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
