% Imprime toda a informação do jogo
display_game(Board-ColoursWon, 0) :-
    print_board(Board, 1),
    display_discs(Board-ColoursWon).

display_game(Board-ColoursWon, Player) :- % Switch Player every time we end printing the board.
    print_board(Board, 1),
    display_discs(Board-ColoursWon),
    display_player(Player).

% Imprime número de discos disponíveis
display_discs(GameState) :-
    countDiscs(GameState, O, G, P),
    NewO is 42 - O,
    NewG is 42 - G,
    NewP is 42 - P,
    write('   Orange discs: '), write(NewO), 
    write(' | Green discs: '), write(NewG),
    write(' | Purple discs: '), write(NewP),nl.

% Imprime a vez do próximo Jogador
display_player(Player) :-
    write('                      Player '),
    write(Player),
    write('\'s turn'), nl, nl.

% Imprime as cores que cada jogador já arrecadou
displayColoursState(Player, 'FALSE'-'FALSE'-'FALSE') :- write('Player '), write(Player), write(' has no colours'),nl.

displayColoursState(Player, PurpleWon-OrangeWon-GreenWon) :-
    write('Player '), write(Player), write(' has colour(s): '), 
    displayColourWon('PURPLE', PurpleWon),
    displayColourWon('ORANGE', OrangeWon),
    displayColourWon('GREEN', GreenWon),
    nl, nl.

% Display de cor ganha
displayColourWon(_, 'FALSE').

displayColourWon(Colour, 'TRUE') :-
    write(Colour), write(' ').