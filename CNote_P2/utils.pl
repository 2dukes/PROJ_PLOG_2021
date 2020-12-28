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

getNewInt(Int) :-
    (
        catch(read(Int), _, true),
        read_line(_),
        integer(Int),
        nl
    ).

getDimension(N) :-
    repeat,
    getDimensionAux(N), !.

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

reset_timer :- statistics(walltime,_).	
print_time :-
	statistics(walltime,[_,T]),
	TS is ((T//10)*10)/1000,
	nl, write('Time: '), write(TS), write('s'), nl, nl.

readPuzzleInput(N, M) :-
    write('Insert Number of Lines: '),
    getDimension(N),
    write('Insert Number of Columns: '),
    getDimension(M).

selRandom(Var, _, BB0, BB1):- % seleciona valor de forma aleatória
    fd_set(Var, Set), fdset_to_list(Set, List),
    random_member(Value, List), % da library(random)
    ( first_bound(BB0, BB1), Var #= Value ;
    later_bound(BB0, BB1), Var #\= Value ).