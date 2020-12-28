
mainMenu :-
    repeat,
    (
        checkInput(Input),
        \+manageInput(Input) 
    ).

% Verifica se o input do menu é válido
checkInput(Input) :-
    printMainMenu,
    repeat,
    (checkInputAux(Input)), !. 

checkInputAux(Input) :-
    askMenuOption,
    getNewInt(Input),
    Input >= 0,
    Input =< 4, !.

checkInputAux(_) :- 
    nl, write('ERROR: Invalid Option!'), nl, nl, 
    fail.

% Prompt da nova opção a inserir
askMenuOption :-
    write('> Insert your option ').  

manageInput(0, _) :- % Exit
    write('\nExiting...\n\n'), fail.

manageInput(1) :- % Inserir puzzle e resolver
    solveCNote.

manageInput(2) :- % Gerar puzzle dinamicamente e resolver
    generateCNote.

manageInput(3) :- % Escolher puzzle e resolver
    hardCNote.

manageInput(4) :-
    nl,
    write('._______________________________________________________________.'), nl,
    write('|                                                               |'), nl,                                        
    write('|                             ABOUT                             |'), nl,  
    write('|===============================================================|'), nl,              
    write('|      Given an initial grid filled with digits from 1 to 9,    |'), nl,
    write('|  the grid must be completed by adding one more digit in every |'), nl,
    write('|  cell to the right or left of the initial digit, so that the  |'), nl,
    write('|      sum of all elements in every row and column is 100.      |'), nl,
    write('|_______________________________________________________________|'), nl,
    getChar(_).

% Menu Principal
printMainMenu :-
    nl, nl,
    write(' ________________________________________________________________ '), nl,
    write('|                                                                |'), nl,
    write('|                 ___     __                                       |'), nl,
    write('|                / __\\ /\\ \\ \\___ | |_ ___                      |'), nl,
    write('|               / /   /  \\/ / _ \\| __/ _ \\                      |'), nl,
    write('|              / /___/ /\\  / (_) | ||  __/                        |'), nl,
    write('|              \\____/\\_\\ \\/ \\___/ \\__\\___|                  |'), nl,
    write('|                                                                |'), nl,
    write('|                                                                |'), nl,                                           
    write('|                         Davide Castro                          |'), nl,  
    write('|                               &                                |'), nl, 
    write('|                            Rui Pinto                           |'), nl,
    write('|================================================================|'), nl,              
    write('|                                                                |'), nl,
    write('|                       1. Insert     Puzzle                     |'), nl,
    write('|                       2. Generate   Puzzle                     |'), nl,
    write('|                       3. Choose     Puzzle                     |'), nl,
    write('|                                                                |'), nl,
    write('|                            4. About                            |'), nl,
    write('|                            0. Exit                             |'), nl,     
    write('|________________________________________________________________|'), nl.                                                                                                                               

% (Ogre)
%                                   
%    ___     __      _       
%   / __\ /\ \ \___ | |_ ___ 
%  / /   /  \/ / _ \| __/ _ \
% / /___/ /\  / (_) | ||  __/
% \____/\_\ \/ \___/ \__\___|

