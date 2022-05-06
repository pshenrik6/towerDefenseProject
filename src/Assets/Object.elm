module Assets.Object exposing (Properties, init)


type alias Properties = 
    { width : Int
    , height : Int
    , xCoord : Int
    , yCoord : Int
    , image : String
    , type : a
    }

init : a -> Properties
init type =
    { height = 5
    , width = 5
    , xCoord = 0
    , yCoord = 0
    , image = "Foo"
    , type = type
    }