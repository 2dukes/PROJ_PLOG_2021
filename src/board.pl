:- use_module(library(lists)).
:- dynamic initial/1.
:- dynamic player/1.
:- dynamic green/1.
:- dynamic orange/1.
:- dynamic purple/1.

initial([
    [nodef, nodef, nodef, space, empty, empty, empty, empty, empty, nodef, nodef, nodef],
    [nodef, nodef, empty, empty, empty, empty, empty, empty, empty, empty, nodef, nodef],
    [nodef, space, empty, empty, empty, empty, empty, empty, empty, empty, empty, nodef],
    [nodef, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, nodef],
    [space, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [space, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [space, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [nodef, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, nodef],
    [nodef, space, empty, empty, empty, empty, empty, empty, empty, empty, empty, nodef],
    [nodef, nodef, empty, empty, empty, empty, empty, empty, empty, empty, nodef, nodef],
    [nodef, nodef, nodef, space, empty, empty, empty, empty, empty, nodef, nodef, nodef]
]).

% - For demonstration purposes only -

updateBoard_Mid :- % Updates board to an intermediary state.
    mid(MidState),
    retract(initial(_)),
    assert(initial(MidState)).

mid([
    [nodef, nodef, nodef, space, empty, purple, empty, empty, empty, nodef, nodef, nodef],
    [nodef, nodef, empty, empty, purple, empty, empty, empty, empty, empty, nodef, nodef],
    [nodef, space, empty, empty, empty, empty, empty, empty, empty, empty, empty, nodef],
    [nodef, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, nodef],
    [space, empty, empty, green, empty, empty, empty, empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty, empty, orange, empty, empty, empty, empty, empty],
    [space, empty, empty, empty, empty, empty, empty, green, empty, empty, empty, empty],
    [empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [space, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty, empty],
    [nodef, empty, empty, empty, empty, empty, orange, empty, empty, empty, empty, nodef],
    [nodef, space, empty, empty, empty, empty, empty, empty, empty, empty, empty, nodef],
    [nodef, nodef, empty, empty, empty, empty, empty, empty, empty, empty, nodef, nodef],
    [nodef, nodef, nodef, space, empty, empty, empty, empty, empty, nodef, nodef, nodef]
]).

updateBoard_Final :- % Updates board to a final state.
    final(FinalState),
    retract(initial(_)),
    assert(initial(FinalState)).

final([
    [nodef, nodef, nodef, space, empty, purple, empty, empty, empty, nodef, nodef, nodef],
    [nodef, nodef, empty, empty, purple, empty, empty, empty, empty, empty, nodef, nodef],
    [nodef, space, empty, empty, purple, empty, empty, empty, empty, empty, empty, nodef],
    [nodef, empty, empty, empty, purple, empty, empty, empty, empty, empty, empty, nodef],
    [space, empty, empty, green, purple, empty, empty, empty, empty, empty, empty, empty],
    [empty, empty, empty, empty, purple, empty, orange, empty, empty, empty, empty, empty],
    [space, empty, empty, empty, purple, empty, empty, green, empty, empty, empty, empty],
    [empty, empty, empty, empty, purple, empty, empty, empty, empty, empty, empty, empty],
    [space, empty, empty, empty, purple, empty, empty, empty, empty, empty, empty, empty],
    [nodef, empty, empty, empty, purple, empty, orange, empty, empty, empty, empty, nodef],
    [nodef, space, empty, empty, purple, empty, empty, empty, empty, empty, empty, nodef],
    [nodef, nodef, empty, empty, purple, empty, empty, empty, empty, empty, nodef, nodef],
    [nodef, nodef, nodef, space, purple, empty, empty, empty, empty, nodef, nodef, nodef]
]).

% - End of "demonstration purposes only" -

% Board atoms:
code(empty, ' ').
code(orange, 'O').
code(purple, 'P').
code(green, 'G').
code(nodef, '      ').
code(space, '   ').

orange(42).
purple(42).
green(42).

print_top([]).
print_top([C | L]) :- % Displays the top part of a line of the board.
    (
        (
            C \= nodef,
            C \= space,
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
    updatePlayer(NewPlayer).

display_game([L | T], Player) :- % Displays the current Board.
    print_line(L),
    display_game(T, Player).

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
