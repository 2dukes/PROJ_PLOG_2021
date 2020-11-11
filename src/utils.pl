getInt(Int) :- 
    (
        catch(read(Int), _, true),
        read_line(_),
        integer(Int),
        nl
    );
    (
        write('Invalid input!'), nl, % write(Int),%Insert number: '),
        getInt(Int)
    ).


getChar(Char) :-
    get_char(Char),
    read_line(_),
    nl.