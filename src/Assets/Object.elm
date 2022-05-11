module Assets.Object exposing (Properties, init)


type alias Properties a =
    { width : Int
    , height : Int
    , xCoord : Int
    , yCoord : Int
    , image : String
    , objectType : a
    }


init : a -> Properties a
init objectType =
    { height = 5
    , width = 5
    , xCoord = 0
    , yCoord = 0
    , image = "Foo"
    , objectType = objectType
    }
