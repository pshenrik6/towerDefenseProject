module Level exposing (Level(..), init)

import General exposing (Point(..))


type Level
    = LevelGame
        { grid : List ( Int, List ( Int, Int ) )
        }


init =
    LevelGame
        { grid =
            [ ( 0, [ ( 0, 0 ), ( 1, 1 ), ( 2, 0 ), ( 3, 0 ), ( 4, 0 ) ] )
            , ( 1, [ ( 0, 1 ), ( 1, 1 ), ( 2, 1 ), ( 3, 0 ), ( 4, 0 ) ] )
            , ( 2, [ ( 0, 0 ), ( 1, 0 ), ( 2, 1 ), ( 3, 0 ), ( 4, 0 ) ] )
            , ( 3, [ ( 0, 0 ), ( 1, 0 ), ( 2, 1 ), ( 3, 1 ), ( 4, 1 ) ] )
            , ( 4, [ ( 0, 0 ), ( 1, 0 ), ( 2, 0 ), ( 3, 0 ), ( 4, 0 ) ] )
            ]
        }





-- type Level
--     = LevelGame
--         { grid : List (List Int)
--         }


-- init : Level
-- init =
--     LevelGame
--         { grid = [ [ 0, 1, 0, 0, 0 ],
--                    [ 1, 1, 1, 0, 0 ],
--                    [ 0, 1, 1, 0, 0 ],
--                    [0, 0, 1, 1, 1 ],
--                    [0, 0, 0, 0, 0 ] ]
--         }


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

