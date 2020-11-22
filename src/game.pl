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
            findall(Row-Diagonal, orange1(Row, Diagonal), StartPoints),
            Predicate = orange2
        );
        (   
            Colour == purple,
            findall(Row-Diagonal, purple1(Row, Diagonal), StartPoints),
            Predicate = purple2
        );
        (   
            Colour == green,
            findall(Row-Diagonal, green1(Row, Diagonal), StartPoints),
            Predicate = green2
        )
    ),
    (
        max_depth(MaxDepth),
        % write('Starting Points '), write(StartPoints), nl, 
        % write('NotAlliedColour '), write(NotAlliedColour), nl,
        newGetDistance(StartPoints, [], NotAlliedColour, MaxDepth, 0, Distance, Board, Predicate)
        % distanceToEdge(P1, Board, NotAlliedColour, Predicate, 0, Result1),
        % distanceToEdge(P2, Board, NotAlliedColour, Predicate, 0, Result2),
        % distanceToEdge(P3, Board, NotAlliedColour, Predicate, 0, Result3),
        % distanceToEdge(P4, Board, NotAlliedColour, Predicate, 0, Result4),
        % distanceToEdge(P5, Board, NotAlliedColour, Predicate, 0, Result5),
        % min_member(Distance, [Result1, Result2, Result3, Result4, Result5])
    ).
    

% distanceToEdge([Row,Diagonal], Board, NotAlliedColour, Predicate, Depth, Result) :-
%     (
%         (
%             Depth =< MaxDepth,
%             (
%                 (
                    
%                     % getDistance(Row-Diagonal, Board, NotAlliedColour, [],  Predicate, 'TRUE', Depth, 0, Result1),
%                     Result = Result1
%                 );
%                 (
%                     NewDepth is Depth + 1, !,
%                     distanceToEdge([Row,Diagonal], Board, NotAlliedColour, Predicate, NewDepth, Result)
%                 )
%             )
%         );
%         (
%             Depth > MaxDepth,
%             Result is 2000
%         )
%     ).