module Assets.Type.Projectile.Boulder exposing (Properties, init)

import Assets.Object


type alias Properties =
    { damage : Int
    , speed : Int
    }


init : Assets.Object.Properties
init =
    Assets.Object.init
        { damage = 10
        , speed = 4
        }
