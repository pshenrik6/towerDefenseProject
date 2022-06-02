module Assets.Type.Enemy exposing (Enemy, initWarrior,getEnemyHeight,getEnemyPos,getEnemyXCoord,getEnemyYCoord)

import Assets.Object
import General exposing (Point(..), Direction(..))
import Svg.Attributes exposing (direction)


type alias Enemy =
    { speed : Int
    , health : Int
    , direction : Direction
    , xGridPos : Int
    , yGridPos : Int
    }


initWarrior : Assets.Object.Object Enemy
initWarrior =
    Assets.Object.init
        20
        20
        10
        10
        "Foo"
        { speed = 10
        , health = 50
        , direction = Right
        , xGridPos = 1
        , yGridPos = 1
        }

getEnemySpeed : Assets.Object.Object Enemy ->Int
getEnemySpeed enemy =  enemy.objectType.speed

getEnemyHeight : Assets.Object.Object Enemy ->Int
getEnemyHeight enemy = enemy.height

getEnemyXCoord : Assets.Object.Object Enemy ->Int
getEnemyXCoord enemy = enemy.xCoord


getEnemyYCoord : Assets.Object.Object Enemy ->Int
getEnemyYCoord enemy = enemy.yCoord

getEnemyPos : Assets.Object.Object Enemy -> Point
getEnemyPos enemy = ( Point enemy.xCoord enemy.yCoord)