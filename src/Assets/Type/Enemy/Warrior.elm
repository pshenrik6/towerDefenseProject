module Assets.Type.Enemy.Warrior exposing (Properties, init)

import Assets.Object exposing (Properties)


type alias Properties =
    { speed : Int
    , health : Int
    }


init : Assets.Object.Properties Properties
init =
    Assets.Object.init
        { speed = 10
        , health = 50
        }
