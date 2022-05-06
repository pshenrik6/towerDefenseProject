module Assets.Type.Tower.Small exposing (Properties, init)

import Assets.Object
import Assets.Type.Projectile.Boulder


type alias Properties =
    { turnSpeed : Int
    , projectile : a
    , fireRate : Int
    , name : String
    , range : Int
    , price : Int
    }


init : Assets.Object.Properties
init =
    Assets.Object.init
        { turnSpeed = 5
        , projectile = Assets.Type.Projectile.Boulder.init
        , fireRate = 5
        , range = 80
        , name = "Klein"
        , price = 10
        }
