module Main exposing (main)

import Assets.Type.Enemy exposing (Enemy, getEnemyHeight, getEnemyPos, getEnemyWidth, getEnemyXCoord, getEnemyYCoord, initWarrior)
import Browser
import Browser.Events exposing (onAnimationFrame)
import Debug exposing (log)
import General exposing (Area(..), OneField(..), Point(..), oneFildTest)
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Level exposing (Level(..), init)
import Svg exposing (Svg, rect, svg)
import Svg.Attributes exposing (fill, height, opacity, speed, stroke, viewBox, width, x, y)


type alias Model =
    { field : Area
    , status : Status
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
                                        ( { model | attacker = Attacker { origin = Point (xEnemy + enemy.speed) yEnemy, width = enemy.width, height = enemy.height, speed = enemy.speed, name = enemy.name} }, Cmd.none )

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
    , attacker = attacker
    , levelPaths = pathsList oneFildTest Level.init
    }


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

                else
                    "blue"
             )
                number
            )
        , opacity "50%"
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


update : Maybe Msg -> Model -> ( Model, Cmd (Maybe Msg) )
update msg model =
    case model.status of
        Running ->
            case msg of
                Just Pause ->
                    ( model, Cmd.none )

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


view : Model -> Html (Maybe Msg)
view model =
    case model.attacker of
        Attacker a ->
            case model.field of
                Rect field ->
                    div []
                        [ div [ style "text-align" "center" ]
                            [ svg
                                [ width (String.fromInt field.width)
                                , height (String.fromInt field.height)
                                , fill "#ccf"
                                , viewBox ("0 0 " ++ String.fromInt field.width ++ String.fromInt field.height)
                                ]
                                (drawObject 3 a.origin a.width a.height
                                    :: drawObject 4 (getEnemyPos initWarrior) (getEnemyWidth initWarrior) (getEnemyHeight initWarrior)
                                    :: board oneFildTest Level.init
                                )
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
