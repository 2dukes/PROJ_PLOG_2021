initialBoard([
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

code(empty, ' ').
code(orange, 'O').
code(purple, 'P').
code(gr, 'G').
code(nodef, '      ').
code(space, '   ').

%print_hex(C) :- write(' ___ '), nl,
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

print_board([]).
print_board([L | T]) :-
    print_line(L),
    print_board(T).

print_initial :-
    initialBoard(InitialBoard),
    print_board(InitialBoard).
