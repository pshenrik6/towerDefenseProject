module Level exposing (Level(..), init)

import General exposing (Point(..))


type Level
    = LevelGame
        { grid : List (List Int)
        }


init : Level
init =
    LevelGame
        { grid = [ [ 0, 1, 0, 0, 0 ], [ 0, 1, 1, 0, 0 ], [ 0, 0, 1, 0, 0 ], [ 0, 0, 1, 1, 1 ], [ 0, 0, 0, 0, 0 ] ]
        }


type Field
    = FieldGround { dem : Point, artField : Int, isPassed : Bool }



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

