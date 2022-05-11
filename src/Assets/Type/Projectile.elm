module Assets.Type.Projectile exposing (Projectile, initBoulder)

import Assets.Object


type alias Projectile =
    { damage : Int
    , speed : Int
    }


initBoulder : Assets.Object.Object Projectile
initBoulder =
    Assets.Object.init
        20
        20
        10
        10
        "Foo"
        { damage = 10
        , speed = 4
        }
