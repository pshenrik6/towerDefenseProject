module Level exposing (Level, init )
import Assets.Type.Enemy exposing (Enemy, initWarrior)
import Assets.Type.Projectile exposing (Projectile)

import General exposing (Point(..))
import List exposing (indexedMap)
import Assets.Object exposing (Object)
import String exposing (toInt)



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


-- getPositionInGrid : Int -> Int -> List ( Int, List ( Int, Int ) ) -> Int
-- getPositionInGrid x y grid =
--     grid [ y ] [ x ]



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
