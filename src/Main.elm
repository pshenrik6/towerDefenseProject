module Main exposing (main)

import Assets.Object exposing (Object)
import Assets.Type.Enemy exposing (Enemy)
import Assets.Type.Projectile exposing (Projectile)
import Assets.Type.Tower exposing (Tower)
import Browser
import Browser.Events
import General exposing (Area(..), Point(..))
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Level exposing (Level(..), init)
import Svg exposing (Svg, rect, svg)
import Svg.Attributes exposing (fill, height, opacity, speed, stroke, viewBox, width, x, y)


type alias Model =
    { field : Area
    , status : Status
    }


type Status
    = Running
    | Collision
    | StartGame
    | PauseGame


type Msg
    = Pause


type Attacker
    = Attacker { origin : Point, width : Int, height : Int, speed : Int, name : String }


attacker : Attacker
attacker =
    Attacker { origin = Point 80 20, width = 20, height = 20, speed = 1, name = "Standard Enemy" }


oneFildTest : OneField
oneFildTest =
    RectField { origin = Point 0 0, width = 60, height = 60 }


type OneField
    = RectField { origin : Point, width : Int, height : Int }


initField : Area
initField =
    Rect { origin = Point 0 0, width = 800, height = 400, floorLevel = 40 }


init : Model
init =
    { field = initField
    , status = PauseGame
    }


initTowerList : List (Object (Tower (Object Projectile)))
initTowerList =
    [ Assets.Type.Tower.initBigTower, Assets.Type.Tower.initSmallTower ]


gameSpace : Area -> Svg (Maybe Msg)
gameSpace (Rect field) =
    case field.origin of
        Point xOrigin yOrigin ->
            rect
                [ x (String.fromInt xOrigin)
                , y (String.fromInt yOrigin)
                , width (String.fromInt field.width)
                , height (String.fromInt field.height)
                ]
                []


drawAttacker : Attacker -> Svg (Maybe Msg)
drawAttacker (Attacker field) =
    case field.origin of
        Point xOrigin yOrigin ->
            rect
                [ x (String.fromInt xOrigin)
                , y (String.fromInt yOrigin)
                , width (String.fromInt field.width)
                , height (String.fromInt field.height)
                , fill "blue"
                ]
                []


drawField : Int -> OneField -> Svg (Maybe Msg)
drawField number (RectField field) =
    case field.origin of
        Point xOrigin yOrigin ->
            if number == 0 then
                rect
                    [ x (String.fromInt xOrigin)
                    , y (String.fromInt yOrigin)
                    , width (String.fromInt field.width)
                    , height (String.fromInt field.height)
                    , fill "brown"
                    , opacity "50%"
                    ]
                    []

            else
                rect
                    [ x (String.fromInt xOrigin)
                    , y (String.fromInt yOrigin)
                    , width (String.fromInt field.width)
                    , height (String.fromInt field.height)
                    , fill "green"
                    , opacity "50%"
                    ]
                    []


board : OneField -> Level -> List (Svg (Maybe Msg))
board (RectField field) (LevelGame l) =
    case l.grid of
        h :: hs ->
            case field.origin of
                Point xOrigin yOrigin ->
                    let
                        boardHelp (RectField sfield) listh =
                            case listh of
                                x :: xs ->
                                    case sfield.origin of
                                        Point xOrigins yOrigins ->
                                            drawField x (RectField sfield) :: boardHelp (RectField { origin = Point (xOrigins + field.height) yOrigins, height = field.height, width = field.width }) xs

                                [] ->
                                    board (RectField { origin = Point xOrigin (yOrigin + field.height), height = field.height, width = field.width }) (LevelGame { grid = hs })
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

                _ ->
                    ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )


view : Model -> Html (Maybe Msg)
view model =
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
                        (gameSpace model.field
                            :: drawAttacker attacker
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
        [--Browser.Events.onKeyDown keyDecoder
        ]
