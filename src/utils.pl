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

% replaceNth(+List, +Index, +Value, -NewList).
replaceNth([_|T], 0, X, [X|T]).
replaceNth([H|T], I, X, [H|R]):- I > -1, NI is I-1, replaceNth(T, NI, X, R), !.
replaceNth(L, _, _, L).


% countOccurrence(+List, +Value, -Count)
countOccurrence([] , _,0). % empty list, count of anything is 0. Base case.

countOccurrence([H|T] , H,NewCount):-
    countOccurrence(T,H, OldCount),
    NewCount is OldCount + 1.

countOccurrence([H|T], H2, Count):-
    H \= H2, 
    countOccurrence(T,H2,Count).

execute(Function, Args) :-
    Run =.. [Function | Args], 
    Run.

countDiscs([], 0, 0, 0).
countDiscs([Line | Rest], OrangeDiscs, GreenDiscs, PurpleDiscs) :-
    countOccurrence(Line, orange, AuxOrangeDiscs),
    countOccurrence(Line, green, AuxGreenDiscs),
    countOccurrence(Line, purple, AuxPurpleDiscs),
    countDiscs(Rest, Oranges, Greens, Purples),
    OrangeDiscs is Oranges + AuxOrangeDiscs,
    GreenDiscs is Greens + AuxGreenDiscs,
    PurpleDiscs is Purples + AuxPurpleDiscs.

 clear :- write('\33\[2J').
    