module Assets.Type.Enemy exposing (Enemy, initWarrior)

import Assets.Object
import General exposing (Direction(..), Point(..))


type alias Enemy =
    { speed : Int
    , health : Int
    , currentDirection : Direction
    }


initWarrior : Direction -> Assets.Object.Object Enemy
initWarrior direction =
    Assets.Object.init
        20
        20
        80
        -30
        "Foo"
        { speed = 10
        , health = 50
        , currentDirection = direction
        }
