module Main exposing (main)

import Assets.Object exposing (Object)
import Assets.Type.Enemy exposing (Enemy)
import Assets.Type.Projectile exposing (Projectile)
import Assets.Type.Tower exposing (Tower)
import Browser
import Browser.Events exposing (onAnimationFrame)
import Debug exposing (log)
import General exposing (Area(..), OneField(..), Point(..), oneFildTest)
import Html exposing (Html, button, div, img, span, table, td, text, tr)
import Html.Attributes exposing (src, style)
import Html.Events exposing (onClick)
import Level exposing (Level(..), init)
import Svg exposing (Svg, rect, svg)
import Svg.Attributes exposing (fill, height, opacity, speed, stroke, viewBox, width, x, y)
import Svg.Events as SvgE


type alias Model =
    { field : Area
    , status : Status
    , towerList : List (Object (Tower (Object Projectile)))
    , enemyList : List (Object Enemy)
    , selectedTower : Object (Tower (Object Projectile))
    , selectedField : ( Int, Int )
    , attacker : Attacker
    , levelPaths : List Point
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
    = Attacker { origin : Point, width : Int, height : Int, speed : Int, name : String }


attacker : Attacker
attacker =
    Attacker { origin = Point 120 60, width = 20, height = 20, speed = 1, name = "Standard Enemy" }



-- attacker (120,60)
-- Pathlist
-- [Point 120 0,Point 120 60,Point 180 60,Point 180 120,Point 180 180,Point 240 180,Point 300 180]


nextMove : Model -> List Point -> ( Model, Cmd (Maybe Msg) )
nextMove model list =
    case model.attacker of
        Attacker enemy ->
            case enemy.origin of
                Point xEnemy yEnemy ->
                    case list of
                        x :: _ ->
                            case x of
                                Point xPath yPath ->
                                    if xEnemy == xPath && yEnemy > yPath then
                                        ( { model | attacker = Attacker { origin = Point xEnemy (yEnemy - enemy.speed), width = enemy.width, height = enemy.height, speed = enemy.speed, name = enemy.name } }, Cmd.none )

                                    else if xEnemy == xPath && yEnemy < yPath then
                                        ( { model | attacker = Attacker { origin = Point xEnemy (yEnemy + enemy.speed), width = enemy.width, height = enemy.height, speed = enemy.speed, name = enemy.name } }, Cmd.none )

                                    else if yEnemy == yPath && xEnemy > xPath then
                                        ( { model | attacker = Attacker { origin = Point (xEnemy - enemy.speed) yEnemy, width = enemy.width, height = enemy.height, speed = enemy.speed, name = enemy.name } }, Cmd.none )

                                    else if yEnemy == yPath && xEnemy < xPath then
                                        ( { model | attacker = Attacker { origin = Point (xEnemy + enemy.speed) yEnemy, width = enemy.width, height = enemy.height, speed = enemy.speed, name = enemy.name } }, Cmd.none )

                                    else
                                        ( { model | attacker = Attacker { origin = Point xEnemy yEnemy, width = enemy.width, height = enemy.height, speed = enemy.speed, name = enemy.name } }, Cmd.none )

                        [] ->
                            ( { model | attacker = Attacker { origin = Point xEnemy yEnemy, width = enemy.width, height = enemy.height, speed = enemy.speed, name = enemy.name } }, Cmd.none )


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
    , levelPaths = pathsList oneFildTest Level.init
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


board : OneField -> Level -> List (Svg (Maybe Msg))
board (RectField field) (LevelGame level) =
    case level.grid of
        h :: hs ->
            case field.origin of
                Point xOrigin yOrigin ->
                    let
                        boardHelp (RectField sfield) listh =
                            case listh of
                                x :: xs ->
                                    case sfield.origin of
                                        Point xOrigins yOrigins ->
                                            drawObject x sfield.origin sfield.width sfield.height
                                                :: boardHelp (RectField { origin = Point (xOrigins + field.width) yOrigins, height = field.height, width = field.width }) xs

                                [] ->
                                    board (RectField { origin = Point xOrigin (yOrigin + field.height), height = field.height, width = field.width }) (LevelGame { grid = hs })
                    in
                    boardHelp (RectField field) h

        [] ->
            []


pathsList : OneField -> Level -> List Point
pathsList (RectField field) (LevelGame level) =
    case level.grid of
        h :: hs ->
            case field.origin of
                Point xOrigin yOrigin ->
                    let
                        boardHelp (RectField sfield) listh =
                            case listh of
                                x :: xs ->
                                    case sfield.origin of
                                        Point xOrigins yOrigins ->
                                            if x == 1 then
                                                Point (xOrigins + field.width) yOrigins :: boardHelp (RectField { origin = Point (xOrigins + field.width) yOrigins, height = field.height, width = field.width }) xs

                                            else
                                                boardHelp (RectField { origin = Point (xOrigins + field.width) yOrigins, height = field.height, width = field.width }) xs

                                [] ->
                                    pathsList (RectField { origin = Point xOrigin (yOrigin + field.height), height = field.height, width = field.width }) (LevelGame { grid = hs })
                    in
                    boardHelp (RectField field) h

        [] ->
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
                    -- let
                    --     _ =
                    --         Debug.log "pathsList" (pathsList oneFildTest Level.init)
                    -- in
                    case model.attacker of
                        Attacker enemy ->
                            case enemy.origin of
                                Point xEnemy yEnemy ->
                                    case model.levelPaths of
                                        x :: xs ->
                                            case x of
                                                Point xPath yPath ->
                                                    if xEnemy == xPath && yEnemy == yPath then
                                                        nextMove { model | levelPaths = xs } model.levelPaths

                                                    else
                                                        nextMove model model.levelPaths

                                        [] ->
                                            ( { model | attacker = Attacker { origin = Point xEnemy yEnemy, width = 20, height = 20, speed = 1, name = "Standard Enemy" } }, Cmd.none )

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
        [ onAnimationFrame (\_ -> Just MoveAttacker)
        ]



-- point : Point
-- point =
--     Point 20 20
-- moveAttacker : Model -> ( Model, Cmd (Maybe Msg) )
-- moveAttacker model =
--     ( { model | attacker = moveNextStep model.attacker point }, Cmd.none )
-- moveAttacker : Model -> ( Model, Cmd (Maybe Msg) )
-- moveAttacker model = case model.attacker of Attacker a -> case a.origin of Point x y ->  ({ model | attacker =  Attacker { origin = Point (x+1) (y+1), width = 20, height = 20, speed = 1, name = "Standard Enemy" }},Cmd.none)
-- moveNextStep : Attacker -> Point -> Attacker
-- moveNextStep (Attacker enemy) (Point x y) =
--     case enemy.origin of
--         Point xEnemy yEnemy ->
--             if xEnemy == x then
--                 if y > yEnemy then
--                     Attacker { origin = Point xEnemy (yEnemy - enemy.speed), width = 20, height = 20, speed = 1, name = "Standard Enemy" }
--                 else
--                     Attacker { origin = Point xEnemy (yEnemy - enemy.speed), width = 20, height = 20, speed = 1, name = "Standard Enemy" }
--             else if yEnemy > y then
--                 Attacker { origin = Point (xEnemy + enemy.speed) yEnemy, width = 20, height = 20, speed = 1, name = "Standard Enemy" }
--             else
--                 Attacker { origin = Point (xEnemy - enemy.speed) 20, width = 20, height = 20, speed = 1, name = "Standard Enemy" }
