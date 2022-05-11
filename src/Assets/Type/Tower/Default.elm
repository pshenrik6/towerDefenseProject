module Assets.Type.Tower.Default exposing (Properties, init)

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


init : Assets.Object.Properties Properties
init =
    Assets.Object.init
        { turnSpeed = 2
        , projectile = Assets.Type.Projectile.Boulder.init
        , fireRate = 2
        , range = 100
        , name = "Standard"
        , price = 20
        }
