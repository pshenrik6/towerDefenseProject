module Assets.Type.Enemy.Warrior exposing (Warrior, init)

import Assets.Object


type alias Warrior =
    { speed : Int
    , health : Int
    }


init : Assets.Object.Properties
init =
    Assets.Object.init
        { speed = 10
        , health = 50
        }
