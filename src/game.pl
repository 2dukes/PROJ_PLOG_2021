% Depth máxima que o algoritmo greedy suporta (cobre todos os caminhos possíveis)
max_depth(2000).

% Dado um Board, unifica em Value o seu valor, sendo depois o mesmo utilizado para definir a melhor jogada no momento
value(Board-ColoursWon, Player, Value) :-
    findall(Colour1-AlliedColour1-NotAlliedColour1, colourTable(Player, Colour1-AlliedColour1-NotAlliedColour1), ColourTables),
    findall(ValueColour, ( member(Colour2-_-NotAlliedColour2, ColourTables), 
        evaluateColour(Board-ColoursWon, Colour2-NotAlliedColour2, ValueColour) ), 
        ValueColours),
    sumlist(ValueColours, Value).
    
% Avalia a distância a uma determinada Colour, unificando ValueColour
evaluateColour(Board-ColoursWon, Colour-NotAlliedColour, ValueColour) :-
    getDistanceColour(Board-ColoursWon, Colour-NotAlliedColour, Distance),
    evaluateColourDistance(Distance, ValueColour), !.

evaluateColourDistance(Distance, ValueColour) :-
    Distance is 2000,
    ValueColour is 0.

evaluateColourDistance(Distance, ValueColour) :-
    NewDistance is Distance + 1,
    ValueColour is 20 / NewDistance.

% Verifica se uma cor já foi ou não ganha; se não então computa a distância que o jogador demora para a encontrar.
getDistanceColour(Board-ColourState, Colour-NotAlliedColour, Distance) :-
    !,    
    getColourStartingPoints(Colour, ColourState, StartPoints, Predicate),
    max_depth(MaxDepth),
    newGetDistance(StartPoints, [], NotAlliedColour, MaxDepth, 0, Distance, Board, Predicate).

getDistanceColour(_, _, 2000).

getColourStartingPoints(orange, _-'FALSE'-_, StartPoints, orange2) :-
    findall(Row-Diagonal, orange1(Row, Diagonal), StartPoints).

getColourStartingPoints(purple, 'FALSE'-_-_, StartPoints, purple2) :-
    findall(Row-Diagonal, orange1(Row, Diagonal), StartPoints).
    
getColourStartingPoints(green, _-_-'FALSE', StartPoints, green2) :-
    findall(Row-Diagonal, green1(Row, Diagonal), StartPoints).