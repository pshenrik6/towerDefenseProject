module General exposing (..)
type Area
    = Rect { origin : Point, width : Int, height : Int, floorLevel : Int }

type Point
    = Point Int Int