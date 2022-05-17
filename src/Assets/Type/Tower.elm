module Assets.Type.Tower exposing (Tower, initBigTower, initSmallTower)

import Assets.Object
import Assets.Type.Projectile


type alias Tower a =
    { turnSpeed : Int
    , projectile : a
    , fireRate : Int
    , name : String
    , range : Int
    , price : Int
    }


initSmallTower : Assets.Object.Object (Tower (Assets.Object.Object Assets.Type.Projectile.Projectile))
initSmallTower =
    Assets.Object.init
        20
        20
        10
        10
        "tower.png"
        { turnSpeed = 5
        , projectile = Assets.Type.Projectile.initBoulder
        , fireRate = 5
        , range = 80
        , name = "Klein"
        , price = 10
        }


initBigTower : Assets.Object.Object (Tower (Assets.Object.Object Assets.Type.Projectile.Projectile))
initBigTower =
    Assets.Object.init
        50
        50
        10
        10
        "tower.png"
        { turnSpeed = 5
        , projectile = Assets.Type.Projectile.initBoulder
        , fireRate = 5
        , range = 80
        , name = "Gross"
        , price = 10
        }
