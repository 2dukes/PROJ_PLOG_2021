
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
        distanceToEdge(P1, Board, NotAlliedColour, Predicate, 0, Result1),
        distanceToEdge(P2, Board, NotAlliedColour, Predicate, 0, Result2),
        distanceToEdge(P3, Board, NotAlliedColour, Predicate, 0, Result3),
        distanceToEdge(P4, Board, NotAlliedColour, Predicate, 0, Result4),
        distanceToEdge(P5, Board, NotAlliedColour, Predicate, 0, Result5),
        min_member(Distance, [Result1, Result2, Result3, Result4, Result5])
    ).
    

distanceToEdge([Row,Diagonal], Board, NotAlliedColour, Predicate, Depth, Result) :-
    Depth =< 5,
    (
        (
            getDistance(Row-Diagonal, Board, NotAlliedColour, [],  Predicate, 'TRUE', Depth, 0, Result1),
            Result = Result1
        );
        (
            NewDepth is Depth + 1, !,
            distanceToEdge([Row,Diagonal], Board, NotAlliedColour, Predicate, NewDepth, Result)
        )
    ).

getDistance(Row-Diagonal, Board, NotAlliedColour, _,  Predicate, DistanceFind, Depth, Distance, Result) :- 
    execute(Predicate, [Row , Diagonal]), 
    getCellByCoords(Board, Row, Diagonal, Cell),
    Cell \= NotAlliedColour,
    !,
    (
        (
          DistanceFind == 'FALSE',
          Cell \= empty
        ); 
        DistanceFind == 'TRUE'
    ),
    (
        (
            Cell == empty,
            Distance < Depth,
            Result is Distance + 1
        );
        (
            Cell \= empty,
            Distance =< Depth,
            Result is Distance
        )
    ).

getDistance(Row-Diagonal, Board, NotAlliedColour, AlreadyVisited, Predicate, DistanceFind, Depth, Distance, Result) :-
    \+ member([Row, Diagonal], AlreadyVisited),
    getCellByCoords(Board, Row, Diagonal, AnalizeCell),
    AnalizeCell \= NotAlliedColour,
    Distance =< Depth,
    (
        (   
            DistanceFind == 'FALSE',
            AnalizeCell \= empty
        );
        (
            DistanceFind == 'TRUE',
            (
                (
                    AnalizeCell == empty,
                    NewDistance is Distance + 1
                );
                NewDistance is Distance
            )
        )
    ),
    (   
        (NewRow1 is Row - 2, NewDiagonal1 is Diagonal - 1),
        (NewRow2 is Row - 1, NewDiagonal2 is Diagonal),
        (NewRow3 is Row + 1, NewDiagonal3 is Diagonal + 1),
        (NewRow4 is Row + 1, NewDiagonal4 is Diagonal),
        (NewRow5 is Row + 2, NewDiagonal5 is Diagonal + 1),
        (NewRow6 is Row - 1, NewDiagonal6 is Diagonal - 1)
    ),
    !,
    (
        append(AlreadyVisited, [[Row, Diagonal],
            [NewRow2, NewDiagonal2],[NewRow3, NewDiagonal3],[NewRow4, NewDiagonal4],[NewRow5, NewDiagonal5],[NewRow6, NewDiagonal6]], 
            NewAlreadyVisited1),
        append(AlreadyVisited, [[Row, Diagonal],
            [NewRow1, NewDiagonal1],[NewRow3, NewDiagonal3],[NewRow4, NewDiagonal4],[NewRow5, NewDiagonal5],[NewRow6, NewDiagonal6]], 
            NewAlreadyVisited2),
        append(AlreadyVisited, [[Row, Diagonal],
            [NewRow1, NewDiagonal1],[NewRow2, NewDiagonal2],[NewRow4, NewDiagonal4],[NewRow5, NewDiagonal5],[NewRow6, NewDiagonal6]], 
            NewAlreadyVisited3),
        append(AlreadyVisited, [[Row, Diagonal],
            [NewRow1, NewDiagonal1],[NewRow2, NewDiagonal2],[NewRow3, NewDiagonal3],[NewRow5, NewDiagonal5],[NewRow6, NewDiagonal6]], 
            NewAlreadyVisited4),
        append(AlreadyVisited, [[Row, Diagonal],
            [NewRow1, NewDiagonal1],[NewRow2, NewDiagonal2],[NewRow3, NewDiagonal3],[NewRow4, NewDiagonal4],[NewRow6, NewDiagonal6]], 
            NewAlreadyVisited5),
        append(AlreadyVisited, [[Row, Diagonal],
            [NewRow1, NewDiagonal1],[NewRow2, NewDiagonal2],[NewRow3, NewDiagonal3],[NewRow4, NewDiagonal4],[NewRow5, NewDiagonal5]], 
            NewAlreadyVisited6),
        (
            getDistance(NewRow3-NewDiagonal3, Board, NotAlliedColour, NewAlreadyVisited3, Predicate, DistanceFind, Depth, NewDistance, Result);
            getDistance(NewRow4-NewDiagonal4, Board, NotAlliedColour, NewAlreadyVisited4, Predicate, DistanceFind, Depth, NewDistance, Result);
            getDistance(NewRow5-NewDiagonal5, Board, NotAlliedColour, NewAlreadyVisited5, Predicate, DistanceFind, Depth, NewDistance, Result);
            getDistance(NewRow2-NewDiagonal2, Board, NotAlliedColour, NewAlreadyVisited2, Predicate, DistanceFind, Depth, NewDistance, Result);
            getDistance(NewRow6-NewDiagonal6, Board, NotAlliedColour, NewAlreadyVisited6, Predicate, DistanceFind, Depth, NewDistance, Result);
            getDistance(NewRow1-NewDiagonal1, Board, NotAlliedColour, NewAlreadyVisited1, Predicate, DistanceFind, Depth, NewDistance, Result)
        )
    ).


% distanceToEdge(Row, Diagonal, Board, NotAlliedColour, AlreadyVisited, Visited, BorderPredicate, Distance) :-
%     (
%         (
%             (
%                 (
%                     member([Row, Diagonal], AlreadyVisited),
%                     NewVisited = AlreadyVisited
%                 );
%                 (
%                     getCellByCoords(Board, Row, Diagonal, Cell),
%                     Cell == NotAlliedColour,
%                     append(AlreadyVisited, [[Row, Diagonal]], NewVisited)
%                 );
%                 (
%                     \+getCellByCoords(Board, Row, Diagonal, Cell),
%                     NewVisited = AlreadyVisited
%                 )
%             ),
%             Distance = 2000
%         );
%         (  
%             execute(BorderPredicate, [Row, Diagonal]),
%             Distance = 0
%         )
%     ),
%     (Visited = NewVisited).%, write('parei: '), write(Row), write(', '), write(Diagonal), nl).
