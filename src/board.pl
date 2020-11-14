
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

purple1(1,1).
purple1(2,1).
purple1(3,1).
purple1(4,1).
purple1(5,1).

purple2(19,13).
purple2(20,13).
purple2(21,13).
purple2(22,13).
purple2(23,13).

green2(1,2).
green2(2,3).
green2(3,4).
green2(4,5).
green2(5,6).

green1(19,8).
green1(20,9).
green1(21,10).
green1(22,11).
green1(23,12).

orange1(8, 2).
orange1(10,3).
orange1(12,4).
orange1(14,5).
orange1(16,6).

orange2(8, 8).
orange2(10,9).
orange2(12,10).
orange2(14,11).
orange2(16,12).

initial([
[                                         purple,    empty],                            %1
[                                     empty,   empty,   empty],                         %2
[                                purple,    empty,   empty,  empty],                     %3
[                           empty,    purple,    purple,   empty,   empty],               %4
[                      empty,    empty,    purple,   purple,   empty,   empty],           %5
[                          purple,     empty,   purple,   purple,    empty],               %6
[                      empty,    empty,    purple,   purple,   purple,   empty],           %7 
[                 purple,   empty,     purple,   purple,   empty,    empty,   empty],      %8
[                      purple,    empty,    empty,   purple,   empty,   empty],           %9
[                 purple,   empty,     empty,   empty,   purple,    empty,   empty],      %10
[                      purple,    empty,    empty,   purple,   purple,   empty],           %11
[                 purple,   empty,     empty,   purple,   purple,    empty,   empty],      %12
[                      purple,    empty,    empty,   empty,   purple,   empty],           %13
[                 purple,   empty,     empty,   empty,   purple,    empty,   empty],      %14
[                      empty,    empty,    empty,   empty,   purple,   empty],           %15
[                 empty,   empty,     empty,   empty,   purple,    empty,   empty],      %16
[                      empty,    empty,    empty,   empty,   purple,   empty],           %17
[                           empty,    purple,   empty,    purple,   empty],               %18
[                      purple,    purple,    empty,   empty,   purple,   empty],           %19
[                           purple,    empty,   empty,   empty,   empty],                %20
[                                purple,    empty,   empty,   empty],                    %21
[                                     purple,   empty,   empty],                         %22
[                                          empty,   empty]                              %23
]).

runPath(Row, Diagonal, Board, NotAlliedColour, _,  Predicate) :- 
    getCellByCoords(Board, Row, Diagonal, Cell),
    Cell \= NotAlliedColour,
    Cell \= empty,
    execute(Predicate, [Row , Diagonal]), !.

runPath(Row, Diagonal, Board, NotAlliedColour, AlreadyVisited, Predicate) :-
    \+ member([Row, Diagonal], AlreadyVisited),
    getCellByCoords(Board, Row, Diagonal, AnalizeCell),
    AnalizeCell \= empty, AnalizeCell \= NotAlliedColour,
    Row >=1, Row =< 23, Diagonal >= 1, Diagonal =< 13, 
    (
        (
            NewRow1 is Row - 2,
            NewDiagonal1 is Diagonal - 1
        ),
        (
            NewRow2 is Row - 1,
            NewDiagonal2 is Diagonal
        ),
        (
            NewRow3 is Row + 1,
            NewDiagonal3 is Diagonal + 1
        ),
        (
            NewRow4 is Row + 1,
            NewDiagonal4 is Diagonal
        ),
        (
            NewRow5 is Row + 2,
            NewDiagonal5 is Diagonal + 1
        ),
        (
            NewRow6 is Row - 1,
            NewDiagonal6 is Diagonal - 1
        )
    ),
    (
        append(AlreadyVisited, [[Row, Diagonal],
            [NewRow2, NewDiagonal2],[NewRow3, NewDiagonal3],[NewRow4, NewDiagonal4],[NewRow5, NewDiagonal5],[NewRow6, NewDiagonal6]], 
            NewAlreadyVisited1),
        append(AlreadyVisited, [[Row, Diagonal],
            [NewRow1, NewDiagonal1],[NewRow3, NewDiagonal3],[NewRow4, NewDiagonal4],[NewRow5, NewDiagonal5],[NewRow6, NewDiagonal6]], 
            NewAlreadyVisited2),
        append(AlreadyVisited, [[Row, Diagonal],
            [NewRow1, NewDiagonal1],[NewRow2, NewDiagonal2],[NewRow4, NewDiagonal4],[NewRow5, NewDiagonal5],[NewRow6, NewDiagonal6]], 
            NewAlreadyVisited3),
        append(AlreadyVisited, [[Row, Diagonal],
            [NewRow1, NewDiagonal1],[NewRow2, NewDiagonal2],[NewRow3, NewDiagonal3],[NewRow5, NewDiagonal5],[NewRow6, NewDiagonal6]], 
            NewAlreadyVisited4),
        append(AlreadyVisited, [[Row, Diagonal],
            [NewRow1, NewDiagonal1],[NewRow2, NewDiagonal2],[NewRow3, NewDiagonal3],[NewRow4, NewDiagonal4],[NewRow6, NewDiagonal6]], 
            NewAlreadyVisited5),
        append(AlreadyVisited, [[Row, Diagonal],
            [NewRow1, NewDiagonal1],[NewRow2, NewDiagonal2],[NewRow3, NewDiagonal3],[NewRow4, NewDiagonal4],[NewRow5, NewDiagonal5]], 
            NewAlreadyVisited6),
        (
            runPath(NewRow1, NewDiagonal1, Board, NotAlliedColour, NewAlreadyVisited1, Predicate);
            runPath(NewRow2, NewDiagonal2, Board, NotAlliedColour, NewAlreadyVisited2, Predicate);
            runPath(NewRow3, NewDiagonal3, Board, NotAlliedColour, NewAlreadyVisited3, Predicate);
            runPath(NewRow4, NewDiagonal4, Board, NotAlliedColour, NewAlreadyVisited4, Predicate);
            runPath(NewRow5, NewDiagonal5, Board, NotAlliedColour, NewAlreadyVisited5, Predicate);
            runPath(NewRow6, NewDiagonal6, Board, NotAlliedColour, NewAlreadyVisited6, Predicate)
        )
    ).

checkBlocked(Row, Diagonal, Board, NotAlliedColour, AlreadyVisited, Visited, _) :-
    (
        (
            member([Row, Diagonal], AlreadyVisited),
            NewVisited = AlreadyVisited
        );
        (  
            (
                getCellByCoords(Board, Row, Diagonal, Cell),
                Cell == NotAlliedColour,
                append(AlreadyVisited, [[Row, Diagonal]], NewVisited)
            );
            (
                \+getCellByCoords(Board, Row, Diagonal, Cell),
                NewVisited = AlreadyVisited
            )
        )
    ),
    (Visited = NewVisited).

checkBlocked(Row, Diagonal, Board, NotAlliedColour, AlreadyVisited, Visited, BorderPredicate) :-
    (
        \+execute(BorderPredicate, [Row, Diagonal]),
        getCellByCoords(Board, Row, Diagonal, AnalizeCell),
        AnalizeCell \= NotAlliedColour
    ),
    (
        (
            member([Row, Diagonal], AlreadyVisited),
            Visited = AlreadyVisited
        );
        (
            getCellByCoords(Board, Row, Diagonal, AnalizeCell),
            AnalizeCell \= NotAlliedColour,
            append(AlreadyVisited, [[Row, Diagonal]], NewAlreadyVisited),
            (
                (
                    NewRow1 is Row - 2,
                    NewDiagonal1 is Diagonal - 1
                ),
                (
                    NewRow2 is Row - 1,
                    NewDiagonal2 is Diagonal
                ),
                (
                    NewRow3 is Row + 1,
                    NewDiagonal3 is Diagonal + 1
                ),
                (
                    NewRow4 is Row + 1,
                    NewDiagonal4 is Diagonal
                ),
                (
                    NewRow5 is Row + 2,
                    NewDiagonal5 is Diagonal + 1
                ),
                (
                    NewRow6 is Row - 1,
                    NewDiagonal6 is Diagonal - 1
                )
            ),
            (
                !,
                % write(NewAlreadyVisited), nl,
                % write('1 adjacent: '), write(NewRow1), write(', '), write(NewDiagonal1), nl,
                checkBlocked(NewRow1, NewDiagonal1, Board, NotAlliedColour, NewAlreadyVisited, Visited1, BorderPredicate),
                !,
                % write(Visited1), nl,
                % write('2 adjacent: '), write(NewRow2), write(', '), write(NewDiagonal2), nl,
                checkBlocked(NewRow2, NewDiagonal2, Board, NotAlliedColour, Visited1, Visited2, BorderPredicate),
                !,
                % write(Visited2), nl,
                % write('3 adjacent: '), write(NewRow3), write(', '), write(NewDiagonal3), nl,
                checkBlocked(NewRow3, NewDiagonal3, Board, NotAlliedColour, Visited2, Visited3, BorderPredicate),
                !,
                % write(Visited3), nl,
                % write('4 adjacent: '), write(NewRow4), write(', '), write(NewDiagonal4), nl,
                checkBlocked(NewRow4, NewDiagonal4, Board, NotAlliedColour, Visited3, Visited4, BorderPredicate),
                !,
                % write(Visited4), nl,
                % write('5 adjacent: '), write(NewRow5), write(', '), write(NewDiagonal5), nl,
                checkBlocked(NewRow5, NewDiagonal5, Board, NotAlliedColour, Visited4, Visited5, BorderPredicate),
                !,
                % write(Visited5), nl,
                % write('6 adjacent: '), write(NewRow6), write(', '), write(NewDiagonal6), nl,
                checkBlocked(NewRow6, NewDiagonal6, Board, NotAlliedColour, Visited5, Visited6, BorderPredicate),
                Visited = Visited6
                %write(Visited), nl
            )
        )
    ).

updateBoard(Board, [Row, Diagonal, Colour], NewBoard) :-
    nth1(Row, Board, Line),
    startDiag(Row, StartDiagonal),
    IndexDiagonal is (Diagonal - StartDiagonal),
    replaceNth(Line, IndexDiagonal, Colour, NewLine),
    RowToUpdate is Row - 1,
    replaceNth(Board, RowToUpdate, NewLine, NewBoard).

checkEmpty([Row, Diagonal, _], Board) :-
    getCellByCoords(Board, Row, Diagonal, Cell),
    Cell == 'empty'.

getCellByCoords(Board, Row, Diagonal, Cell) :-
    verifyCoordinates(Row, Diagonal),
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
            printSpaces(21), write('[P]___  1  ___ 2'), printLineInfo(2), nl
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