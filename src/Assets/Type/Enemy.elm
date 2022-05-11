module Assets.Type.Enemy exposing (Enemy, initWarrior)

import Assets.Object


type alias Enemy =
    { speed : Int
    , health : Int
    }


initWarrior : Assets.Object.Object Enemy
initWarrior =
    Assets.Object.init
        20
        20
        10
        10
        "Foo"
        { speed = 10
        , health = 50
        }
