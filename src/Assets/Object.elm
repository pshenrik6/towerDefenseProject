module Assets.Object exposing (Object, init)


type alias Object a =
    { width : Int
    , height : Int
    , xCoord : Int
    , yCoord : Int
    , image : String
    , objectType : a
    }


init : Int -> Int -> Int -> Int -> String -> a -> Object a
init height width xCoord yCoord image objectType =
    { height = height
    , width = width
    , xCoord = xCoord
    , yCoord = yCoord
    , image = image
    , objectType = objectType
    }
