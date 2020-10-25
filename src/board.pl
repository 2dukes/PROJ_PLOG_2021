% use_module(library(lists)).
:- dynamic initial/1.
:- dynamic player/1.

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

updateBoard_Mid :-
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

updateBoard_Final :-
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

code(empty, ' ').
code(orange, 'O').
code(purple, 'P').
code(green, 'G').
code(nodef, '      ').
code(space, '   ').

% print_hex(C) :- write(' ___ '), nl,
%    put_code(9585), write(' '), code(C, P), write(P), write(' '), put_code(9586), nl,
%    put_code(9586), write('___'), put_code(9585).

print_top([]).
print_top([C | L]) :- 
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
print_mid([C | L]) :-
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
print_bot([C | L]) :-
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
print_line(L) :-
    print_top(L), nl,
    print_mid(L), nl,
    print_bot(L), nl.

player(1). % First Player.
% playerColour(1, 'orange', 'purple'). % Orange | Purple, Purple | Green, Green | Orange -> playerColour(Player, Colour1, Colour2)
% playerColour(2, 'orange', 'green').  % Orange | Green, Purple | Orange, Green | Purple -> playerColour(Player, Colour1, Colour2)


updatePlayer(Colour) :-
    retract(player(_)),
    assert(player(Colour)).

updateBoard(Board) :-
    retract(initial(_)),
    assert(initial(Board)).

display_game([], Player) :- % Switch Player every time we end printing the board.
    NewPlayer is (Player + 1) mod 2,
    updatePlayer(NewPlayer).

display_game([L | T], Player) :-
    print_line(L),
    display_game(T, Player).

col_elem(C, List, Elem, Counter, Aux) :-
    (
        nth0(Aux, List, Result),
        ( 
            (Result == empty ; Result == purple ; Result == orange),
            (
                (
                    Counter == C, Elem = Result
                );
                (
                    NewCounter is Counter + 1,
                    NewAux is Aux + 1,
                    col_elem(C, List, Elem, NewCounter, NewAux)
                )
            )
        );
        (
            NewAux is Aux + 1,
            col_elem(C, List, Elem, Counter, NewAux)
        )
    ).


cell(L, C, Board, Elem) :- % Gives you the cell in a specific Line | Column
    nth0(L, Board, Line),
    col_elem(C, Line, Elem, 0, 0).

% cell(0, 1, InitialBoard, Elem)

play :-
    initial(GameState),
    player(Player), % Assume first player.
    display_game(GameState, Player).
