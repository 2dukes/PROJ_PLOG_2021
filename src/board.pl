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
    [nodef, nodef, nodef, nodef, space, purpleEnd, purpleEnd, purpleEnd, purpleEnd, purpleEnd      ],
    [nodef, nodef, nodef, nodef, space,                          empty, empty, empty, empty, empty                 ],
    [nodef, nodef, orangeEnd,                          empty, empty, empty, empty, empty, empty, empty, empty,          greenEndSpace],
    [nodef, nodef, orangeEndSpace,                empty, empty, empty, empty, empty, empty, empty, empty, empty,          greenEndSpace],
    [nodef, orangeEnd,                          empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,          greenEndSpace],
    [nodef, orangeEndSpace,                  empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,           greenEndSpace],
    [orangeEnd,                          empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,           greenEndSpace],
    [nodef, space,                          empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty                          ],
    [greenEnd,                           empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,           orangeEndSpace],
    [nodef, greenEndSpace,                   empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,           orangeEndSpace],
    [nodef, greenEnd,                           empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,           orangeEndSpace],
    [nodef, nodef, greenEndSpace,                 empty, empty, empty, empty, empty, empty, empty, empty, empty,          orangeEndSpace],
    [nodef, nodef, greenEnd,                           empty, empty, empty, empty, empty, empty, empty, empty,           orangeEndSpace],
    [nodef, nodef, nodef, nodef, space,                          empty, empty, empty, empty, empty                                     ],
    [nodef, nodef, nodef, nodef, space, purpleEnd, purpleEnd, purpleEnd, purpleEnd, purpleEnd]
]).

% - For demonstration purposes only -

updateBoard_Mid :- % Updates board to an intermediary state.
    mid(MidState),
    retract(initial(_)),
    assert(initial(MidState)),
    updateDiscs(2, 2, 2).

mid([
    [nodef, nodef, nodef, nodef, space, purpleEnd, purpleEnd, purpleEnd, purpleEnd, purpleEnd      ],
    [nodef, nodef, nodef, nodef, space,                          empty, purple, empty, empty, empty                 ],
    [nodef, nodef, orangeEnd,                          empty, empty, purple, empty, empty, empty, empty, empty,          greenEndSpace],
    [nodef, nodef, orangeEndSpace,                empty, empty, empty, empty, empty, empty, empty, empty, empty,          greenEndSpace],
    [nodef, orangeEnd,                          empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,          greenEndSpace],
    [nodef, orangeEndSpace,                  empty, empty, green, empty, empty, empty, empty, empty, empty, empty, empty,           greenEndSpace],
    [orangeEnd,                          empty, empty, empty, empty, empty, empty, orange, empty, empty, empty, empty, empty,           greenEndSpace],
    [nodef, space,                          empty, empty, empty, empty, empty, empty, green, empty, empty, empty, empty                          ],
    [greenEnd,                           empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,            orangeEndSpace],
    [nodef, greenEndSpace,                   empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty,           orangeEndSpace],
    [nodef, greenEnd,                           empty, empty, empty, empty, orange, empty, empty, empty, empty, empty,         orangeEndSpace],
    [nodef, nodef, greenEndSpace,                 empty, empty, empty, empty, empty, empty, empty, empty, empty,          orangeEndSpace],
    [nodef, nodef, greenEnd,                           empty, empty, empty, empty, empty, empty, empty, empty,           orangeEndSpace],
    [nodef, nodef, nodef, nodef, space,                          empty, empty, empty, empty, empty                                     ],
    [nodef, nodef, nodef, nodef, space, purpleEnd, purpleEnd, purpleEnd, purpleEnd, purpleEnd]
]).

updateBoard_Final :- % Updates board to a final state.
    final(FinalState),
    retract(initial(_)),
    assert(initial(FinalState)),
    updateDiscs(13, 17, 2).

final([
    [nodef, nodef, nodef, nodef, space, purpleEnd, purpleEnd, purpleEnd, purpleEnd, purpleEnd      ],
    [nodef, nodef, nodef, nodef, space,                          empty, purple, empty, empty, empty                 ],
    [nodef, nodef, orangeEnd,                          empty, empty, purple, empty, empty, empty, empty, empty,          greenEndSpace],
    [nodef, nodef, orangeEndSpace,                empty, empty, purple, empty, empty, empty, empty, empty, green,          greenEndSpace],
    [nodef, orangeEnd,                          empty, empty, empty, purple, empty, empty, empty, empty, green, empty,          greenEndSpace],
    [nodef, orangeEndSpace,                  empty, empty, green, purple, empty, empty, empty, empty, green, empty, empty,           greenEndSpace],
    [orangeEnd,                          empty, empty, empty, empty, purple, green, orange, empty, green, empty, empty, empty,           greenEndSpace],
    [nodef, space,                          empty, empty, empty, purple, empty, empty, green, green, empty, empty, empty                          ],
    [greenEnd,                           empty, empty, empty, empty, purple, empty, green, green, empty, empty, empty, empty,            orangeEndSpace],
    [nodef, greenEndSpace,                   empty, empty, empty, purple, empty, green, empty, empty, empty, empty, empty,           orangeEndSpace],
    [nodef, greenEnd,                           empty, empty, empty, purple, orange, green, empty, empty, empty, empty,         orangeEndSpace],
    [nodef, nodef, greenEndSpace,                 empty, green, purple, green, green, empty, empty, empty, empty,           orangeEndSpace],
    [nodef, nodef, greenEnd,                           green, green, purple, empty, empty, empty, empty, empty,           orangeEndSpace],
    [nodef, nodef, nodef, nodef, space,                          purple, empty, empty, empty, empty                                     ],
    [nodef, nodef, nodef, nodef, space, purpleEnd, purpleEnd, purpleEnd, purpleEnd, purpleEnd]
]).

% - End of "demonstration purposes only" -

updateDiscs(PurpleDiscs, GreenDiscs, OrangeDiscs) :-
    retract(orange(_)),
    retract(green(_)),
    retract(purple(_)),
    assert(orange(OrangeDiscs)),
    assert(green(GreenDiscs)),
    assert(purple(PurpleDiscs)).

print_top([]).
print_top([C | L]) :- % Displays the top part of a line of the board.
    (
        (
            C \= nodef,
            C \= space,
            \+ end(C),
            write(' ____ ')
        );
        (
            code(C, P),
            write(P)
        )
    ), 
    print_top(L).

print_mid([]).
print_mid([C | L]) :- % Displays the middle part of a line of the board.
    (
        (
            C \= nodef,
            C \= space,
            \+ end(C),
            put_code(9585), write('  '), 
            code(C, P), write(P),
            write(' '), put_code(9586)
        );
        (
            code(C, P),
            write(P)
        )
    ),
    print_mid(L).

print_bot([]).
print_bot([C | L]) :- % Displays the bottom part of a line of the board.
    (
        (
            C \= nodef,
            C \= space,
            \+ end(C),
            put_code(9586), write('____'), put_code(9585)
        );
        (
            code(C, P),
            write(P)
        )
    ),
    print_bot(L).

print_line([]).
print_line(L) :- % Displays a full line of the board.
    print_top(L), nl,
    print_mid(L), nl,
    print_bot(L), nl.

player(1). % First Player.

updatePlayer(Number) :- % Update the current player dinamically.
    retract(player(_)),
    assert(player(Number)).

updateBoard(Board) :- % Update board dynamically.
    retract(initial(_)),
    assert(initial(Board)).

display_game([], Player) :- % Switch Player every time we end printing the board.
    NewPlayer is (Player + 1) mod 2,
    updatePlayer(NewPlayer),
    display_discs,
    display_player(Player).

display_game([L | T], Player) :- % Displays the current Board.
    print_line(L),
    display_game(T, Player).

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
