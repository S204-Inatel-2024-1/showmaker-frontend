module Pages.Home exposing (..)

import Browser exposing (Document)
import Html exposing (div, p, text)
import Shared exposing (Shared)


type alias Model =
    {}


type Msg
    = Msg


defaultModel : Model
defaultModel =
    {}


init : Model -> Shared -> ( Model, Cmd Msg )
init model _ =
    ( model, Cmd.none )


update : Msg -> Model -> Shared -> ( Model, Cmd Msg )
update msg model _ =
    case msg of
        Msg ->
            ( model, Cmd.none )


view : Model -> Shared -> Document Msg
view _ _ =
    { title = ""
    , body =
        [ div
            []
            [ p
                []
                [ text "Hello World!" ]
            ]
        ]
    }
