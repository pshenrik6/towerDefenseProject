module Main exposing (main)

import Assets.Object exposing (Object)
import Assets.Type.Enemy exposing (Enemy, initWarrior)
import Assets.Type.Projectile exposing (Projectile)
import Assets.Type.Tower exposing (Tower)
import Browser
import Browser.Events exposing (onAnimationFrame)
import Debug exposing (log)
<<<<<<< HEAD
import General exposing (Area(..), Direction(..), OneField(..), Point(..), oneFildTest)
import Html exposing (Html, button, div, img, span, text)
=======
import General exposing (Area(..), OneField(..), Point(..), oneFildTest)
import Html exposing (Html, button, div, img, span, table, td, text, tr)
>>>>>>> origin/hedo
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import Level exposing (Level(..), init)
import List exposing (drop, take)
import List.Extra exposing (getAt)
import Random
import Svg exposing (Svg, rect, svg)
<<<<<<< HEAD
import Svg.Attributes exposing (direction, fill, height, opacity, speed, stroke, viewBox, width, x, y)
import Time
import Tuple exposing (first, second)
=======
import Svg.Attributes exposing (fill, height, opacity, speed, stroke, viewBox, width, x, y)
import Svg.Events as SvgE
>>>>>>> origin/hedo


type alias Model =
    { field : Area
    , status : Status
    , towerList : List (Object (Tower (Object Projectile)))
    , enemyList : List (Object Enemy)
    , selectedTower : Object (Tower (Object Projectile))
    , selectedField : ( Int, Int )
    , attacker : Attacker
    , level : Level
    , enemy : Object Enemy
    }


type Status
    = Running
    | Collision
    | StartGame
    | PauseGame


type Msg
    = Pause
    | SelectItem (Object (Tower (Object Projectile)))
    | SelectField Int Int Int
    | MoveAttacker


type Attacker
    = Attacker { origin : Point, width : Int, height : Int, speed : Int, name : String, actuelPosition : Point, oldPosition : Point }


attacker : Attacker
attacker =
    Attacker { origin = Point 50 50, width = 20, height = 20, speed = 1, name = "Standard Enemy", actuelPosition = Point 0 1, oldPosition = Point -1 -1 }


moveAttackerPoint : Direction -> Point -> Point
moveAttackerPoint direction (Point x y) =
    case direction of
        Left ->
            Point (x - 20) y

        Up ->
            Point x (y - 20)

        Right ->
            Point (x + 20) y

        Down ->
            Point x (y + 20)


initField : Area
initField =
    Rect { origin = Point 0 0, width = 800, height = 400, floorLevel = 40 }


init : Model
init =
    { field = initField
    , status = Running
    , towerList = initTowerList
    , enemyList = initEnemyList
    , selectedTower = Assets.Type.Tower.initBigTower
    , selectedField = ( 0, 0 )
    , attacker = attacker
    , level = Level.init
    , enemy = initWarrior
    }


initTowerList : List (Object (Tower (Object Projectile)))
initTowerList =
    [ Assets.Type.Tower.initBigTower, Assets.Type.Tower.initSmallTower ]


initEnemyList : List (Object Enemy)
initEnemyList =
    [ Assets.Type.Enemy.initWarrior ]


drawObject : Int -> Point -> Int -> Int -> Svg (Maybe Msg)
drawObject number (Point xOrigin yOrigin) objectWidth objectheight =
    rect
        [ x (String.fromInt xOrigin)
        , y (String.fromInt yOrigin)
        , width (String.fromInt objectWidth)
        , height (String.fromInt objectheight)
        , fill
            ((\x ->
                if x == 0 then
                    "brown"

                else if x == 1 then
                    "green"

                else if x == -1 then
                    "pink"

                else
                    "blue"
             )
                number
            )
        , opacity "50%"
        , SvgE.onClick (Just (SelectField number (xOrigin - objectWidth) (yOrigin - objectheight)))
        ]
        []


drawObject1 : Int -> Int -> Int -> Int -> Int -> Svg (Maybe Msg)
drawObject1 number xOrigin yOrigin objectWidth objectheight =
    rect
        [ x (String.fromInt xOrigin)
        , y (String.fromInt yOrigin)
        , width (String.fromInt objectWidth)
        , height (String.fromInt objectheight)
        , fill
            ((\x ->
                if x == 0 then
                    "brown"

                else if x == 1 then
                    "green"

                else
                    "blue"
             )
                number
            )
        , opacity "50%"
        ]
        []


toKey : String -> Maybe Msg
toKey string =
    Nothing


setSelectedField : Model -> Int -> Int -> Int -> Model
setSelectedField model typ x y =
    case typ of
        0 ->
            Debug.log ("Selected field typ " ++ String.fromInt typ ++ " is: " ++ String.fromInt x ++ "x " ++ String.fromInt y ++ "y")
                { model | selectedField = ( x, y ) }

        _ ->
            model


update : Maybe Msg -> Model -> ( Model, Cmd (Maybe Msg) )
update msg model =
    case model.status of
        Running ->
            case msg of
                Just Pause ->
                    ( model, Cmd.none )

                Just (SelectItem tower) ->
                    ( { model | selectedTower = tower }, Cmd.none )

                Just (SelectField typ x y) ->
                    ( setSelectedField model typ x y, Cmd.none )

                Just MoveAttacker ->
                    case Level.init of
                        LevelGame levelUpdateInit ->
                            let
                                _ =
                                    Debug.log "get at" (maybeToElement2 (getAt 0 levelUpdateInit.grid))
                                _ =
                                    Debug.log "enemy" (model.enemy.yCoord)  

                                --  _ =
                                --      Debug.log "pathsList" (test Level.init (Point 0 1 ) (Point 0 0 ))
                            in
                            --testMove model
                            moveEnemy model

                _ ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


previewTowerList : List (Object (Tower (Object Projectile))) -> List (Html (Maybe Msg))
previewTowerList list =
    case list of
        [] ->
            [ td [] [ text ">" ] ]

        tower :: xs ->
            previewTowerListItemImage tower
                :: previewTowerListItemDetails tower
                :: previewTowerList xs


previewTowerListItemImage : Object (Tower (Object Projectile)) -> Html (Maybe Msg)
previewTowerListItemImage tower =
    td [] [ span [] [ img [ src ("img/" ++ tower.image), Html.Attributes.width 40, Html.Attributes.height 40 ] [] ] ]


previewTowerListItemDetails : Object (Tower (Object Projectile)) -> Html (Maybe Msg)
previewTowerListItemDetails tower =
    td
        []
        [ table []
            [ tr [] [ td [] [ span [] [ text ("Name: " ++ tower.objectType.name) ] ] ]
            , tr [] [ td [] [ span [] [ text ("Price: " ++ String.fromInt tower.objectType.price) ] ] ]
            , tr [] [ td [] [ span [] [ text ("FireRate: " ++ String.fromInt tower.objectType.fireRate) ] ] ]
            , tr [] [ td [] [ span [] [ text ("Range: " ++ String.fromInt tower.objectType.range) ] ] ]
            , tr [] [ td [] [ button [ onClick (Just (SelectItem tower)) ] [ text "Add" ] ] ]
            ]
        ]


drawSelectionBoard : Model -> Html (Maybe Msg)
drawSelectionBoard model =
    table []
        [ tr [] (td [] [ text "<" ] :: previewTowerList model.towerList)
        ]


drawSelectionDetailBox : Model -> Html (Maybe Msg)
drawSelectionDetailBox model =
    table [ style "background-color" "blue" ]
        [ tr [] [ td [] [ img [ src ("img/" ++ model.selectedTower.image), Html.Attributes.width 40, Html.Attributes.height 40 ] [] ] ]
        , tr [] [ td [] [ text ("Name: " ++ model.selectedTower.objectType.name) ] ]
        , tr [] [ td [] [ text ("Level: " ++ String.fromInt model.selectedTower.objectType.level) ] ]
        , tr [] [ td [] [ button [] [ text ("Level Up for: " ++ String.fromInt (model.selectedTower.objectType.price * model.selectedTower.objectType.level) ++ "$") ] ] ]
        ]


view : Model -> Html (Maybe Msg)
view model =
    case model.attacker of
        Attacker a ->
            case model.field of
                Rect field ->
                    case model.enemyList of
                        [] ->
                            div [] []

                        enemy :: xs ->
                            div []
                                [ table []
                                    [ tr []
                                        [ td []
                                            [ div [ style "text-align" "center" ]
                                                [ svg
                                                    [ width (String.fromInt field.width)
                                                    , height (String.fromInt field.height)
                                                    , fill "#ccf"
                                                    , viewBox ("0 0 " ++ String.fromInt field.width ++ String.fromInt field.height)
                                                    ]
                                                    (drawObject 3 a.origin a.width a.height
                                                        :: drawObject 4 (Point enemy.xCoord enemy.yCoord) enemy.width enemy.height
                                                        :: board oneFildTest Level.init
                                                    )
                                                ]
                                            ]
                                        , td []
                                            [ drawSelectionDetailBox model
                                            ]
                                        ]
                                    , tr []
                                        [ td []
                                            [ drawSelectionBoard model
                                            ]
                                        ]
<<<<<<< HEAD
                                        [ drawObject1 4 model.enemy.xCoord model.enemy.yCoord a.width a.height

                                        -- drawObject 4 a.origin a.width a.height
                                        ]

                                    -- (drawObject 3 a.origin a.width a.height
                                    --     :: drawObject 4 (Point enemy.xCoord enemy.yCoord) enemy.width enemy.height
                                    --     :: board oneFildTest Level.init
                                    -- )
=======
>>>>>>> origin/hedo
                                    ]
                                ]


main : Program () Model (Maybe Msg)
main =
    Browser.element
        { init = \_ -> ( init, Cmd.none )
        , subscriptions = subscriptions
        , view = view
        , update = update
        }


subscriptions : Model -> Sub (Maybe Msg)
subscriptions _ =
    Sub.batch
        [ Time.every 1000 (\_ -> Just MoveAttacker)
        ]


moveEnemy : Model -> ( Model, Cmd (Maybe Msg) )
moveEnemy model =
    case Level.init of
        LevelGame levelInit ->
            case LevelGame { grid = drop model.enemy.xCoord levelInit.grid } of
                LevelGame levelUpdate ->
                    case levelUpdate.grid of
                        [] ->
                            ( model, Cmd.none )

                        ( _, row ) :: _ ->
                            let
                                right =
                                    maybeToElement (getAt (model.enemy.objectType.yGridPos + 1) row)

                                left =
                                    maybeToElement (getAt (model.enemy.objectType.yGridPos - 1) row)

                                up =
                                    maybeToElement (getAt model.enemy.objectType.yGridPos (second (maybeToElement2 (getAt (model.enemy.objectType.xGridPos - 1) levelInit.grid))))

                                down =
                                    maybeToElement (getAt model.enemy.objectType.yGridPos (second (maybeToElement2 (getAt (model.enemy.objectType.xGridPos + 1) levelInit.grid))))
                            in ( { model | enemy = Assets.Object.init model.enemy.width model.enemy.height model.enemy.xCoord (model.enemy.yCoord + 20)  model.enemy.image { speed = model.enemy.objectType.speed, health = model.enemy.objectType.health, direction = Down, xGridPos = model.enemy.objectType.xGridPos + 1, yGridPos = model.enemy.objectType.yGridPos }, level = LevelGame { grid = drop (model.enemy.objectType.xGridPos + 1) levelInit.grid } }, Cmd.none )
                            
                            -- if second right == 1 && (model.enemy.objectType.direction == Down || model.enemy.objectType.direction == Up || model.enemy.objectType.direction == Right) then
                            --     ( { model | enemy = Assets.Object.init (model.enemy.xCoord + 20) model.enemy.yCoord model.enemy.width model.enemy.height model.enemy.image { speed = model.enemy.objectType.speed, health = model.enemy.objectType.health, direction = Right, xGridPos = model.enemy.objectType.xGridPos, yGridPos = model.enemy.objectType.yGridPos + 1 }, level = LevelGame levelUpdate }, Cmd.none )

                            -- else if second left == 1 && (model.enemy.objectType.direction == Down || model.enemy.objectType.direction == Up || model.enemy.objectType.direction == Left) then
                            --     ( { model | enemy = Assets.Object.init (model.enemy.xCoord - 20) model.enemy.yCoord model.enemy.width model.enemy.height model.enemy.image { speed = model.enemy.objectType.speed, health = model.enemy.objectType.health, direction = Left, xGridPos = model.enemy.objectType.xGridPos, yGridPos = model.enemy.objectType.yGridPos - 1 }, level = LevelGame levelUpdate }, Cmd.none )

                            -- else if second up == 1 && (model.enemy.objectType.direction == Up || model.enemy.objectType.direction == Right || model.enemy.objectType.direction == Left) then
                            --     ( { model | enemy = Assets.Object.init model.enemy.xCoord (model.enemy.yCoord - 20) model.enemy.width model.enemy.height model.enemy.image { speed = model.enemy.objectType.speed, health = model.enemy.objectType.health, direction = Up, xGridPos = model.enemy.objectType.xGridPos - 1, yGridPos = model.enemy.objectType.yGridPos }, level = LevelGame { grid = drop (model.enemy.objectType.xGridPos - 1) levelInit.grid } }, Cmd.none )

                            -- else
                            --     ( { model | enemy = Assets.Object.init model.enemy.xCoord (model.enemy.yCoord + 20) model.enemy.width model.enemy.height model.enemy.image { speed = model.enemy.objectType.speed, health = model.enemy.objectType.health, direction = Down, xGridPos = model.enemy.objectType.xGridPos + 1, yGridPos = model.enemy.objectType.yGridPos }, level = LevelGame { grid = drop (model.enemy.objectType.xGridPos + 1) levelInit.grid } }, Cmd.none )



-- , xGridPos = model.enemy.objectType.xGridPos + 1
--                                                     case model.enemy.objectType.direction of Right -> if ( second up == 1 ) then   ( { model | model.enemy.objectType.speed = 1 }, Cmd.none )
--                                                                                                       else if ( second down == 1 ) then  ( { model | enemy = {yCoord= model.enemy.objectType.yCoord + 20 , xGridPos = model.enemy.objectType.xGridPos + 1 } , level = LevelGame { grid = drop  (model.enemy.objectType.xGridPos  + 1) levelInit.grid }  }, Cmd.none )
--                                                                                                       else  ( { model | enemy = {xCoord= model.enemy.objectType.xCoord + 20 , xGridPos = model.enemy.objectType.xGridPos + 1 } , level = LevelGame levelUpdate  }, Cmd.none )
--                                                                                              Left -> if ( second up == 1 ) then   ( { model | enemy = {yCoord= model.enemy.objectType.yCoord - 20 , xGridPos = model.enemy.objectType.xGridPos -1 } , level = LevelGame { grid = drop  (model.enemy.objectType.xGridPos -1) levelInit.grid }  }, Cmd.none )
--                                                                                                       else if ( second down == 1 ) then  ( { model | enemy = {yCoord= model.enemy.objectType.yCoord + 20 , xGridPos = model.enemy.objectType.xGridPos + 1 } , level = LevelGame levelUpdate  }, Cmd.none )
--                                                                                                         else  ( { model | enemy = {xCoord= model.enemy.objectType.xCoord - 20 , xGridPos = model.enemy.objectType.xGridPos - 1 } , level = LevelGame levelUpdate   }, Cmd.none )
--                                                                                              Down -> if (second right) then  ( { model | enemy = {xCoord= model.enemy.objectType.xCoord + 20 , xGridPos = model.enemy.objectType.xGridPos + 1 } , level = LevelGame levelUpdate  }, Cmd.none )
--                                                                                                      else if (second left) then   ( { model | enemy = {xCoord= model.enemy.objectType.xCoord - 20 , xGridPos = model.enemy.objectType.xGridPos - 1 } , level = LevelGame levelUpdate   }, Cmd.none )
--                                                                                                      else   ( { model | enemy = {yCoord= model.enemy.objectType.yCoord + 20 , xGridPos = model.enemy.objectType.xGridPos + 1 } , level = LevelGame { grid = drop  (model.enemy.objectType.xGridPos  + 1) levelInit.grid }  }, Cmd.none )
--                                                                                              Up ->  if (second right) then  ( { model | enemy = {xCoord= model.enemy.objectType.xCoord + 20 , xGridPos = model.enemy.objectType.xGridPos + 1 } , level = LevelGame levelUpdate  }, Cmd.none )
--                                                                                                      else if (second left) then   ( { model | enemy = {xCoord= model.enemy.objectType.xCoord - 20 , xGridPos = model.enemy.objectType.xGridPos - 1 } , level = LevelGame levelUpdate   }, Cmd.none )
--                                                                                                      else   ( { model | enemy = {yCoord= model.enemy.objectType.yCoord - 20 , xGridPos = model.enemy.objectType.xGridPos -1 } , level = LevelGame { grid = drop  (model.enemy.objectType.xGridPos -1) levelInit.grid }  }, Cmd.none )
-- {  yCoord = model.enemy.yCoord - 20 , xGridPos = model.enemy.objectType.xGridPos -1 }
-- ( { model | enemy = { model.enemy |  speed = 10  }  , level = LevelGame { grid = drop  (model.enemy.objectType.xGridPos-1) levelInit.grid }  }, Cmd.none )


-- testMove : Model -> ( Model, Cmd (Maybe Msg) )
-- testMove model =
--     case model.attacker of
--         Attacker a ->
--             case a.actuelPosition of
--                 Point xActual yActual ->
--                     case a.oldPosition of
--                         Point xOld yOld ->
--                             case Level.init of
--                                 LevelGame levelInit ->
--                                     case LevelGame { grid = drop xActual levelInit.grid } of
--                                         LevelGame levelUpdate ->
--                                             case levelUpdate.grid of
--                                                 [] ->
--                                                     ( model, Cmd.none )

--                                                 ( _, row ) :: _ ->
--                                                     let
--                                                         right =
--                                                             maybeToElement (getAt (yActual + 1) row)

--                                                         left =
--                                                             maybeToElement (getAt (yActual - 1) row)

--                                                         up =
--                                                             maybeToElement (getAt yActual (second (maybeToElement2 (getAt (xActual - 1) levelInit.grid))))
--                                                     in
--                                                     if second right == 1 && first right /= yOld then
--                                                         ( { model | attacker = Attacker { origin = moveAttackerPoint Right a.origin, width = a.width, height = a.height, speed = a.speed, name = a.name, actuelPosition = Point xActual (yActual + 1), oldPosition = Point xActual yActual }, level = LevelGame levelUpdate }, Cmd.none )

--                                                     else if second left == 1 && first left /= yOld then
--                                                         ( { model | attacker = Attacker { origin = moveAttackerPoint Left a.origin, width = a.width, height = a.height, speed = a.speed, name = a.name, actuelPosition = Point xActual (yActual - 1), oldPosition = Point xActual yActual }, level = LevelGame levelUpdate }, Cmd.none )

--                                                     else if second up == 1 && first (maybeToElement2 (getAt (xActual - 1) levelInit.grid)) /= xOld then
--                                                         ( { model | attacker = Attacker { origin = moveAttackerPoint Up a.origin, width = a.width, height = a.height, speed = a.speed, name = a.name, actuelPosition = Point (xActual - 1) yActual, oldPosition = Point xActual yActual }, level = LevelGame { grid = drop xOld levelInit.grid } }, Cmd.none )

--                                                     else
--                                                         ( { model | attacker = Attacker { origin = moveAttackerPoint Down a.origin, width = a.width, height = a.height, speed = a.speed, name = a.name, actuelPosition = Point (xActual + 1) yActual, oldPosition = Point xActual yActual }, level = LevelGame { grid = drop (xActual + 1) levelInit.grid } }, Cmd.none )


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



-- Point 0 1
--  LevelGame
--         { grid =
--             [ ( 0, [ ( 0, 0 ), ( 1, 1 ), ( 2, 0 ), ( 3, 0 ), ( 4, 0 ) ] )
--             , ( 1, [ ( 0, 1 ), ( 1, 1 ), ( 2, 1 ), ( 3, 0 ), ( 4, 0 ) ] )
--             , ( 2, [ ( 0, 0 ), ( 1, 0 ), ( 2, 1 ), ( 3, 0 ), ( 4, 0 ) ] )
--             , ( 3, [ ( 0, 0 ), ( 1, 0 ), ( 2, 1 ), ( 3, 1 ), ( 4, 1 ) ] )
--             , ( 4, [ ( 0, 0 ), ( 1, 0 ), ( 2, 0 ), ( 3, 0 ), ( 4, 0 ) ] )
--             ]
--         }
-- test : Level -> PointTest -> PointTest -> List PointTest
-- test (LevelGame levelUpdate) (PointTest xActual yActual zd) (PointTest xOld yOld zOld) =
--     case levelUpdate.grid of
--         [] ->
--             []
--         ( _, row ) :: is ->
--             let
--                 right =
--                     maybeToElement (getAt (yActual + 1) row)
--                 left =
--                     maybeToElement (getAt (yActual - 1) row)
--                 -- up =
--                 --     maybeToElement (getAt yActual (second (maybeToElement2 (getAt (xActual-1 ) levelUpdate.grid))))
--             in
--             if second right == 1 && first right /= yOld then
--                 PointTest xActual yActual zd :: test (LevelGame levelUpdate) (PointTest xActual (yActual + 1) zd) (PointTest xActual yActual zd)
--             else if second left == 1 && first left /= yOld then
--                 PointTest xActual yActual zd :: test (LevelGame levelUpdate) (PointTest xActual (yActual - 1) zd) (PointTest xActual yActual zd)
--                 -- else if second up == 1 && first up /= xOld then
--                 --     PointTest xActual yActual zd :: test (LevelGame { grid = drop xOld levelUpdate.grid }) (PointTest (xActual - 1) yActual  zd) (PointTest xActual yActual zd)
--             else
--                 PointTest xActual yActual zd :: test (LevelGame { grid = is }) (PointTest (xActual + 1) yActual zd) (PointTest xActual yActual zd)
