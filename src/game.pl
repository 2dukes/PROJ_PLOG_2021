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
    (
        (
            Distance is 2000,
            ValueColour is 0
        );
        (
            NewDistance is Distance + 1,
            ValueColour is 20 / NewDistance
        )
    ), !.

% Verifica se uma cor já foi ou não ganha; se não então computa a distância que o jogador demora para a encontrar.
getDistanceColour(Board-(PurpleWon-OrangeWon-GreenWon), Colour-NotAlliedColour, Distance) :-
    !,
    (    
        (
            (   
                Colour == orange, OrangeWon \= 'TRUE',
                findall(Row-Diagonal, orange1(Row, Diagonal), StartPoints),
                Predicate = orange2
            );
            (   
                Colour == purple, PurpleWon \= 'TRUE',
                findall(Row-Diagonal, purple1(Row, Diagonal), StartPoints),
                Predicate = purple2
            );
            (   
                Colour == green, GreenWon \= 'TRUE',
                findall(Row-Diagonal, green1(Row, Diagonal), StartPoints),
                Predicate = green2
            )
        ),
        (
            max_depth(MaxDepth),
            newGetDistance(StartPoints, [], NotAlliedColour, MaxDepth, 0, Distance, Board, Predicate)
        )
    );
    (
        Distance is 2000
    ).