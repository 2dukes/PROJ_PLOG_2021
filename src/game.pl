max_depth(2000).


value(Board-ColoursWon, Player, Value) :-
    findall(Colour1-AlliedColour1-NotAlliedColour1, colourTable(Player, Colour1-AlliedColour1-NotAlliedColour1), ColourTables),
    % write(ColourTables),
    findall(ValueColour, ( member(Colour2-_-NotAlliedColour2, ColourTables), 
        % write(Colour2),nl,
        evaluateColour(Board-ColoursWon, Colour2-NotAlliedColour2, ValueColour) ), 
        ValueColours),
    sumlist(ValueColours, Value).
    % write(ColoursWon).
    % write(ValueColours),nl,
    
    % write('Soma lista: '), write(Value),nl.
    
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


getDistanceColour(Board-(PurpleWon-GreenWon-OrangeWon), Colour-NotAlliedColour, Distance) :-
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