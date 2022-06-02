module General exposing (..)
type Area
    = Rect { origin : Point, width : Int, height : Int, floorLevel : Int }

type Point
    = Point Int Int

type OneField
    = RectField { origin : Point, width : Int, height : Int }
type Direction
    = Left
    | Up
    | Right
    | Down
oneFildTest : OneField
oneFildTest =
    RectField { origin = Point 0 0, width = 60, height = 60 }

getFieldPos : OneField -> Point
getFieldPos  (RectField field) = field.origin

getFieldHeight : OneField -> Int
getFieldHeight (RectField field) =field.height

getFieldWidth : OneField -> Int
getFieldWidth (RectField field) =field.width