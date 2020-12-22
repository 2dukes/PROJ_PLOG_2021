% Lê um inteiro com deteção de erros
getInt(Int) :- 
    repeat,
    getIntAux(Int).

getIntAux(Int) :-
    catch(read(Int), _, true),
    read_line(_),
    integer(Int),
    nl.

getIntAux(_) :-
    write('Invalid input! Please try again.'), nl,
    fail.

getDimension(N) :-
    repeat,
    getDimensionAux(N).

getDimensionAux(N) :-
    getInt(N),
    N > 0.

getDimensionAux(_) :-
    write('Invalid dimension. Please try again.'), nl,
    fail.

getLine(Line, M) :-
    repeat,
    getLineAux(Line, M).

getLineAux(Line, M) :-
    catch(read(Line), _, fail),
    read_line(_),
    Line = [_|_],
    length(Line, M).

getLineAux(_, _) :-
    write('Invalid Line. Please try again.'), nl,
    fail.

% % Lê um inteiro sem deteção de erros
% getNewInt(Int) :-
%     (
%         catch(read(Int), _, true),
%         read_line(_),
%         integer(Int),
%         nl
%     ).

% Lê um carater
getChar(Char) :-
    get_char(Char),
    read_line(Line),!,
    (Line == ""; Line == "."),
    nl.