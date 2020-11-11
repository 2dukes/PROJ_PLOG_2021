:- use_module(library(lists)).

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

startDiag(1, 1).
startDiag(2, 1).
startDiag(3, 1).
startDiag(4, 1).
startDiag(5, 1).
startDiag(6, 2).
startDiag(7, 2).
startDiag(8, 2).
startDiag(9, 3).
startDiag(10, 3).
startDiag(11, 4).
startDiag(12, 4).
startDiag(13, 5).
startDiag(14, 5).
startDiag(15, 6).
startDiag(16, 6).
startDiag(17, 7).
startDiag(18, 8).
startDiag(19, 8).
startDiag(20, 9).
startDiag(21, 10).
startDiag(22, 11).
startDiag(23, 12).

orange(42).
purple(42).
green(42).

initial([
[                                         orange,    empty],                             %1
[                                     empty,   empty,   empty],                         %2
[                                empty,    empty,   empty,  empty],                     %3
[                           empty,    empty,    empty,   empty,   empty],               %4
[                      empty,    empty,    empty,   empty,   empty,   empty],           %5
[                          empty,     empty,   empty,   empty,    empty],               %6
[                      empty,    empty,    empty,   empty,   empty,   empty],           %7 
[                 empty,   empty,     empty,   empty,   empty,    empty,   empty],      %8
[                      empty,    empty,    empty,   empty,   empty,   empty],           %9
[                 empty,   empty,     empty,   empty,   empty,    empty,   empty],      %10
[                      empty,    empty,    empty,   empty,   empty,   empty],           %11
[                 empty,   empty,     empty,   empty,   empty,    empty,   empty],      %12
[                      empty,    empty,    empty,   empty,   empty,   empty],           %13
[                 empty,   empty,     empty,   empty,   empty,    empty,   empty],      %14
[                      empty,    empty,    empty,   empty,   empty,   empty],           %15
[                 empty,   empty,     empty,   empty,   empty,    empty,   empty],      %16
[                      empty,    empty,    empty,   empty,   empty,   empty],           %17
[                           empty,    empty,   empty,    empty,   empty],               %18
[                      empty,    empty,    empty,   empty,   empty,   empty],           %19
[                           empty,    empty,   empty,   empty,   empty],                %20
[                                empty,    empty,   empty,   empty],                    %21
[                                     empty,   empty,   empty],                         %22
[                                          empty,   empty]                              %23
]).

updateBoard(Board, Row, Diagonal, Colour, NewBoard) :-
    nth1(Row, Board, Line),
    startDiag(Diagonal, StartDiagonal),
    IndexDiagonal is Diagonal - StartDiagonal,
    replaceNth(Line, IndexDiagonal, Colour, NewLine),
    replaceNth(Board, Row - 1, NewLine, NewBoard).

checkEmpty(Row, Diagonal, Board) :-
    getCellByCoords(Board, Row, Diagonal, Cell),
    Cell == 'empty'.

getCellByCoords(Board, Row, Diagonal, Cell) :-
    nth1(Row, Board, Line),
    startDiag(Row, StartDiagonal),
    Index is (Diagonal - StartDiagonal),
    nth0(Index, Line, Cell).

% spaces([17, 13, 9, 5, 4, 4, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 4, 4, 4, 8, 12, 16]).
spaces([[17, '[P]'], [13,'[P]'], [9, '[P]'], [5, '[P]'], [4, '   '], [4, '   '], [1, '   '], [0, '[O]'], [0, '   '], [0, '[O]'], [0, '   '], [0, '[O]'], [0, '   '], [0, '[O]'], [0, '   '], [0, '[O]'], [0, '   '], [4, '   '], [4, '   '], [4, '[G]'], [8, '[G]'], [12, '[G]'], [16, '[G]']]).

printLineInfo(Nline) :-
    info(Nline, Info),
    write(Info).

printLineNumber(Nline) :-
    line(Nline, Info),
    write(Info).

printColour(Colour) :- write(Colour).

print_board([], _) :- 
    printSpaces(20), write('[G]'), put_code(9586), write('___'), put_code(9585), write('   '), put_code(9586), write('___'), put_code(9585), write('[P]'), nl.
print_board([L | Board], Line) :-
    print_line(L, Line),
    NewLine is Line + 1,
    print_board(Board, NewLine).

print_line([Cell | Line], Nline) :-
    ( 
        (
            Nline == 1,
            printSpaces(24), write('___  1  ___ 2'), printLineInfo(2), nl
        );
        true
    ),
    (
        getSpaces(Spaces, Nline, Colour),
        %nth1(Nline, Spaces, E),
        printSpaces(Spaces),
        printColour(Colour),
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

getSpaces(Spaces, Nline, Colour) :-
    spaces(Aux),
    nth1(Nline, Aux, AuxSpaces),
    nth0(0, AuxSpaces, Spaces),
    nth0(1, AuxSpaces, Colour).

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