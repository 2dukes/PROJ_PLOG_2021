getInt(Int) :- 
    repeat,
    (
        (
            catch(read(Int), _, true),
            read_line(_),
            integer(Int),
            nl
        );
        (
            write('Invalid input!'), nl, % write(Int),%Insert number: '),
            fail
        )
    ).

getChar(Char) :-
    get_char(Char),
    read_line(_),
    nl.

% replace(+List, +Index, +Value, -NewList).
replaceNth([_|T], 0, X, [X|T]).
replaceNth([H|T], I, X, [H|R]):- I > -1, NI is I-1, replaceNth(T, NI, X, R), !.
replaceNth(L, _, _, L).