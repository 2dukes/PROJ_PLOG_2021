max_depth(3).


value(Board-_, Player, Value) :-
    findall(ValueColour, ( colourTable(Player, Colour-_-NotAlliedColour), 
        evaluateColour(Board, Colour-NotAlliedColour, ValueColour) ), ValueColours),
    sumlist(ValueColours, Value).
    
evaluateColour(Board, Colour-NotAlliedColour, ValueColour) :-
    getDistanceColour(Board, Colour-NotAlliedColour, Distance),
    (
        (
            Distance is 2000,
            ValueColour is 0
        );
        (
            NewDistance is Distance + 1,
            ValueColour is 20 / NewDistance
        )
    ),!.


getDistanceColour(Board, Colour-NotAlliedColour, Distance) :-
    (
        (   
            Colour == orange,
            findall([Row, Diagonal], orange1(Row, Diagonal), [P1,P2,P3,P4,P5]),
            Predicate = orange2
        );
        (   
            Colour == purple,
            findall([Row, Diagonal], purple1(Row, Diagonal), [P1,P2,P3,P4,P5]),
            Predicate = purple2
        );
        (   
            Colour == green,
            findall([Row, Diagonal], green1(Row, Diagonal), [P1,P2,P3,P4,P5]),
            Predicate = green2
        )
    ),
    (
        % [[Row-Diagonal-0], [Row-Diagonal-1], ...]
        append([], [[P1-0], [P2-0], [P3-0], [P4-0], [P5-0]], InitialPoints),
        distanceToEdge(InitialPoints, Board, NotAlliedColour, Predicate, 0, Result),
        % distanceToEdge(P2, Board, NotAlliedColour, Predicate, 0, Result2),
        % distanceToEdge(P3, Board, NotAlliedColour, Predicate, 0, Result3),
        % distanceToEdge(P4, Board, NotAlliedColour, Predicate, 0, Result4),
        % distanceToEdge(P5, Board, NotAlliedColour, Predicate, 0, Result5),
        % min_member(Distance, Result)
    ).
    

distanceToEdge(InitialPoints, Board, NotAlliedColour, Predicate, Depth, Result) :-
    max_depth(MaxDepth),
    (
        (
            Depth =< MaxDepth,
            (
                (
                    getDistance(InitialPoints, Board, NotAlliedColour, [],  Predicate, 'TRUE', Depth, 0, -1, []),
                );
                (
                    NewDepth is Depth + 1, !,
                    distanceToEdge(InitialPoints, Board, NotAlliedColour, Predicate, NewDepth, Result)
                )
            )
        );
        (
            Depth > MaxDepth,
            Result is 2000
        )
    ).