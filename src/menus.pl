mainMenu(GameState) :-
    repeat,
    (
        checkInput(Input),
        (
            \+ manageInput(Input, GameState);
            fail
        )
    ).
    

getNewInt(Int) :-
    (
        catch(read(Int), _, true),
        read_line(_),
        integer(Int),
        nl
    ).
    

checkInput(Input) :-
    printMainMenu,
    repeat,
    (
        (
            askMenuOption,
            getNewInt(Input),
            Input >= 0,
            Input =< 3,!
        );
        (
            nl, write('ERROR: Invalid Option!'), nl, nl, 
            fail
        )
    ).

manageInput(0, _) :-
    write('\nExiting...\n\n'), fail.

manageInput(1, GameState) :- % Player vs Player
    gameLoop(GameState, [['FALSE', 'FALSE', 'FALSE'], ['FALSE', 'FALSE', 'FALSE']]).

manageInput(2, GameState) :- % Player vs Computer
    %gameLoop(GameState, [['FALSE', 'FALSE', 'FALSE'], ['FALSE', 'FALSE', 'FALSE']]), fail.
    read(_), clearConsole.

manageInput(3, GameState) :- % Computer vs Computer
    %gameLoop(GameState, [['FALSE', 'FALSE', 'FALSE'], ['FALSE', 'FALSE', 'FALSE']]), fail.
    read(_), clearConsole.

askMenuOption :-
    write('> Insert your option ').                                      


printMainMenu :-
    nl, nl,
    write(' ________________________________________________________________ '), nl,
    write('|                                                                |'), nl,
    write('|               _   _ _ _                                        |'), nl,
    write('|              /_\\ | | (_) __ _ _ __   ___ ___  ___              |'), nl,
    write('|             //_\\\\| | | |/ _` |  _ \\ / __/ _ \\/ __|             |'), nl,
    write('|            /  _  \\ | | | (_| | | | | (_|  __/\\__ \\             |'), nl,
    write('|            \\_/ \\_/_|_|_|\\__,_|_| |_|\\___\\___||___/             |'), nl,
    write('|                                                                |'), nl,
    write('|                                                                |'), nl,                                           
    write('|                         Davide Castro                          |'), nl,  
    write('|                               &                                |'), nl, 
    write('|                            Rui Pinto                           |'), nl,
    write('|================================================================|'), nl,              
    write('|                                                                |'), nl,
    write('|                    1. Player   vs  Player                      |'), nl,
    write('|                    2. Player   vs  Computer                    |'), nl,
    write('|                    3. Computer vs  Computer                    |'), nl,
    write('|                                                                |'), nl,
    write('|                            0. Exit                             |'), nl,     
    write('|________________________________________________________________|'), nl.                                                                 

% (Ogre)
%        _ _ _                            
%   /_\ | | (_) __ _ _ __   ___ ___  ___ 
%  //_\\| | | |/ _` | '_ \ / __/ _ \/ __|
% /  _  \ | | | (_| | | | | (_|  __/\__ \
% \_/ \_/_|_|_|\__,_|_| |_|\___\___||___/