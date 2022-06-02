module Level exposing (Level, init)

import General exposing (Point(..))
import List exposing (indexedMap)


type Levels
    = List Level


type alias Level =
    { grid : List ( Int, List ( Int, Int ) )
    }


level1 : List (List Int)
level1 =
    [ [ 0, 1, 0, 0, 0, 0, 0 ]
    , [ 0, 1, 0, 0, 0, 0, 0 ]
    , [ 0, 1, 1, 0, 1, 1, 1 ]
    , [ 0, 0, 1, 1, 1, 0, 0 ]
    , [ 0, 0, 0, 0, 1, 0, 0 ]
    , [ 0, 0, 0, 0, 1, 1, 1 ]
    ]


init : Level
init =
    { grid = initIndexedGrid level1
    }


initIndexedGrid : List (List Int) -> List ( Int, List ( Int, Int ) )
initIndexedGrid level =
    indexedMap Tuple.pair (listToIndexedMap level)


listToIndexedMap : List (List Int) -> List (List ( Int, Int ))
listToIndexedMap level =
    case level of
        [] ->
            []

        x :: xs ->
            indexedMap Tuple.pair x :: listToIndexedMap xs



-- type Field
--     = FieldGround { dem : Point, artField : Int, isPassed : Bool }
-- Test


type LevelTest
    = LevelGameTest
        { grid :
            List
                (List
                    { artField : Int
                    , isPassed : Bool
                    }
                )
        }
