
getUserInput(Row, Diagonal, Colour) :- 
    getCoordinates(Row, Diagonal),
    getColour(Colour).

getCoordinates(Row, Diagonal) :-
    (
        once(getRow(Row)),
        once(getDiagonal(Diagonal)),
        once(verifyCoordinates(Row, Diagonal))
    );
    (
        write('Invalid coordinates!'), nl,
        getCoordinates(Row, Diagonal)
    ).


getRow(Row) :-
    write('Insert Row [1 - 23]: '),
    getInt(Row).

getDiagonal(Diagonal) :-
    write('Insert Diagonal [1 - 13]: '),
    getInt(Diagonal).

getColour(Colour) :-
    
    (
        write('Insert Colour [G, O, P]: '),
        getChar(Colour),
        verifyColour(Colour)
    );
    (
        write('Invalid Colour!'), nl,
        getColour(Colour)
    ).

verifyColour(Colour) :-
    %write(Colour),
    Colour = 'G';
    Colour = 'P';
    Colour = 'O'.



verifyCoordinates(Row, Diagonal) :-       %passar para outro ficheiro
    verifyRow(Row),
    verifyDiagonal(Diagonal),
    verifyRowDiagonal(Row, Diagonal).

verifyRow(Row) :-
    Row >= 1,
    Row =< 23.

verifyDiagonal(Diagonal) :-
    Diagonal >= 1,
    Diagonal =< 13.

verifyRowDiagonal(Row, Diagonal) :-
    initial(Board),
    startDiag(Row, StartDiagonal),
    nth1(Row, Board, Line),
    length(Line, Len), 
    MaxDiagonal is (StartDiagonal + Len),
    Diagonal >= StartDiagonal, Diagonal < MaxDiagonal. 
    
