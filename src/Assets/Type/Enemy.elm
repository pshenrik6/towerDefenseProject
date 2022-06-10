module Assets.Type.Enemy exposing (Enemy, initWarrior,moveEnemies)
import General exposing (Direction(..), Point(..))
import Svg.Attributes exposing (direction)
import Assets.Object exposing (Object)
import Tuple exposing (second)
import List.Extra exposing (getAt)
import List exposing (drop)
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
       -30
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


moveEnemyByDirection : Direction -> Object Enemy -> Object Enemy
moveEnemyByDirection direction enemy =
    case direction of
        Left ->
            { enemy | xCoord = enemy.xCoord - fieldSize ,  objectType = changeEnemyDirection enemy.objectType Left }

        Up ->
             { enemy | yCoord = enemy.yCoord - fieldSize ,  objectType = changeEnemyDirection enemy.objectType Up}

        Right ->
            { enemy | xCoord = enemy.xCoord + fieldSize ,  objectType = changeEnemyDirection enemy.objectType Right}

        Down ->
            { enemy | yCoord = enemy.yCoord + fieldSize ,  objectType = changeEnemyDirection enemy.objectType Down}
moveEnemies : List (Object Enemy) -> List ( Int, List ( Int, Int ) ) -> List (Object Enemy)
moveEnemies enemies grid =
    let
        moveEnemy enemy =
             case (drop (determinePositionY enemy) grid) of 
                [] ->   enemy
                ( _ , row ) :: _  -> 
                 let
                   right =  maybeToElement (getAt (determinePositionX enemy + 1) row)
                   left  =  maybeToElement (getAt (determinePositionX enemy - 1) row)

                   up = maybeToElement (getAt (determinePositionY enemy) (second (maybeToElement2 (getAt (determinePositionY enemy - 1) grid))))
                --    down = maybeToElement (getAt (determinePositionY enemy) (second (maybeToElement2 (getAt ( determinePositionY enemy + 1) grid))))
                 in
                 
                  if (second right == 1 && enemy.objectType.currentDirection /= Left) then moveEnemyByDirection Right enemy 
                  else if (second left == 1 && enemy.objectType.currentDirection /= Right) then moveEnemyByDirection Left enemy
                  else if (second up == 1 && enemy.objectType.currentDirection /= Down) then moveEnemyByDirection Up enemy
                  else   moveEnemyByDirection Down enemy

                  
     in         
    case enemies of
        [] ->
            []
        enemy :: xs ->
            moveEnemy enemy :: moveEnemies xs grid


maybeToElement : Maybe ( Int, Int ) -> ( Int, Int )
maybeToElement m =
    case m of
        Just a ->
            a

        Nothing ->
            ( 0, 0 )


maybeToElement2 : Maybe ( Int, List ( Int, Int ) ) -> ( Int, List ( Int, Int ) )
maybeToElement2 m =
    case m of
        Just a ->
            a

        Nothing ->
            ( 0, [] )