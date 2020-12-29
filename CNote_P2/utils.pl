% Reads an integer with error detection
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

getNewInt(Int) :-
    (
        catch(read(Int), _, true),
        read_line(_),
        integer(Int),
        nl
    ).

% Reads the dimension grid 
getDimension(N) :-
    repeat,
    getDimensionAux(N), !.

getDimensionAux(N) :-
    getInt(N),
    N > 0.

getDimensionAux(_) :-
    write('Invalid dimension. Please try again.'), nl,
    fail.
% Reads a grid line
getLine(Line, M) :-
    repeat,
    getLineAux(Line, M).

% Checks if the grid's line is indeed a list with M length and with values in [1, 9]
getLineAux(Line, M) :-
    catch(read(Line), _, fail),
    read_line(_),
    Line = [_|_],
    length(Line, M),
    checkValidRow(Line).

getLineAux(_, _) :-
    write('Invalid Line. Please try again.'), nl,
    fail.

% Check if a given row is valid
checkValidRow([]).
checkValidRow([H | T]) :-
    H >= 1 , H =< 9,
    checkValidRow(T).

% Reads a single character
getChar(Char) :-
    get_char(Char),
    read_line(Line),!,
    (Line == ""; Line == "."),
    nl.

% Reset labeling timer
reset_timer :- statistics(walltime,_).

% Print the labeling time on the screen	
print_time :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time: '), write(TS), write('s'), nl, nl.

% Get puzzle grid dimension from user input
readPuzzleInput(N, N) :-
    write('Insert Number of Lines/Columns: '),
    getDimension(N).

% Selects value randomly
selRandomValue(Var, _, BB0, BB1):- 
    fd_set(Var, Set), fdset_to_list(Set, List),
    random_member(Value, List),
    ( first_bound(BB0, BB1), Var #= Value ;
    later_bound(BB0, BB1), Var #\= Value ).

% Selects a random variable
selRandomVariable(ListOfVars, Var, Rest):-
    random_select(Var, ListOfVars, Rest). 