module Main exposing (main)

import Browser
import Browser.Events 
import General exposing (Area(..), Point(..))
import Html exposing (Html, div)
import Html.Attributes exposing (style)
import Json.Decode as Decode exposing (Decoder)
import Svg exposing (Svg, rect, svg)
import Svg.Attributes exposing (fill, height, stroke, viewBox, width, x, y)

type alias Model =
    {
    field : Area
    , status : Status
    }


type Status
    = Running
    | Collision
    | StartGame
    | PauseGame


type Msg
    = Pause

initField : Area
initField =
    Rect { origin = Point 0 0, width = 800, height = 400, floorLevel = 40 }


init : Model
init =
    {  field = initField
       , status = PauseGame
    }


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



keyDecoder : Decoder (Maybe Msg)
keyDecoder =
    Decode.map toKey (Decode.field "key" Decode.string)


toKey : String -> Maybe Msg
toKey string =  Nothing

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
                        , stroke "black"
                        , fill "#ccf"
                        , viewBox ("0 0 " ++ String.fromInt field.width ++ String.fromInt field.height)
                        ]
                        [gameSpace model.field]
                 
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
        [ Browser.Events.onKeyDown keyDecoder
        ]
