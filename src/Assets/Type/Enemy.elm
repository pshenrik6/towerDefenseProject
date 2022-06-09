module Assets.Type.Enemy exposing (Enemy, initWarrior, changeEnemyDirection, determinePositionX,determinePositionY )

import Assets.Object
import General exposing (Direction(..), Point(..))
import Svg.Attributes exposing (direction)
import Assets.Object exposing (Object)
fieldSize : Int
fieldSize =
    60

type alias Enemy =
    { speed : Int
    , health : Int
    , currentDirection : Direction
    }


initWarrior : Direction -> Assets.Object.Object Enemy
initWarrior direction =
    Assets.Object.init
        20
        20
        80
        1
        "Foo"
        { speed = 10
        , health = 50
        , currentDirection = direction
        }
changeEnemyDirection : Enemy -> Direction -> Enemy 
changeEnemyDirection enemy direction = {enemy | currentDirection = direction}

determinePositionX : Object Enemy  -> Int
determinePositionX enemy  =
     floor (( toFloat enemy.xCoord / toFloat fieldSize))

determinePositionY : Object Enemy  -> Int
determinePositionY enemy  =
  floor (( toFloat enemy.yCoord / toFloat fieldSize)) 

