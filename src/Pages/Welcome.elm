module Pages.Welcome exposing (..)

import Browser exposing (Document)
import Html exposing (Attribute, Html, button, div, form, input, label, span, text)
import Html.Attributes exposing (autocomplete, class, placeholder, spellcheck, type_)
import Html.Events exposing (onInput)
import Shared exposing (Shared)


type alias Model =
    { email : String
    , password : String
    , passwordConfirmation : String
    }


type Msg
    = OnEmailChange String
    | OnPasswordChange String
    | OnPasswordConfirmationChange String


defaultModel : Model
defaultModel =
    { email = ""
    , password = ""
    , passwordConfirmation = ""
    }


init : Model -> Shared -> ( Model, Cmd Msg )
init model _ =
    ( model, Cmd.none )


update : Msg -> Model -> Shared -> ( Model, Cmd Msg )
update msg model _ =
    case msg of
        OnEmailChange nextEmail ->
            ( { model | email = nextEmail }
            , Cmd.none
            )

        OnPasswordChange nextPassword ->
            ( { model | password = nextPassword }
            , Cmd.none
            )

        OnPasswordConfirmationChange nextPasswordConfirmation ->
            ( { model | passwordConfirmation = nextPasswordConfirmation }
            , Cmd.none
            )


viewInput : List (Attribute Msg) -> String -> String -> Html Msg
viewInput attributes labelText inputText =
    let
        internalAttrs : List (Attribute Msg)
        internalAttrs =
            [ autocomplete False
            , class "px-4 py-2 rounded outline outline-none text-slate-700"
            , spellcheck False
            ]
    in
    div
        [ class "mt-8 text-slate-700" ]
        [ label
            [ class "font-light focus-within:text-sky-600" ]
            [ text labelText
            , div
                [ class "border border-slate-600 focus-within:border-sky-600 rounded"
                ]
                [ input
                    (internalAttrs ++ attributes)
                    [ text inputText ]
                ]
            ]
        ]


viewEmail : String -> Html Msg
viewEmail email =
    viewInput
        [ onInput OnEmailChange
        , placeholder "user@email.com"
        , type_ "email"
        ]
        "E-mail"
        email


viewPassword : String -> Html Msg
viewPassword password =
    viewInput
        [ onInput OnPasswordChange
        , placeholder "M1nh4S3nH4S3cr3T4!"
        , type_ "password"
        ]
        "Password"
        password


viewPasswordConfirmation : String -> Html Msg
viewPasswordConfirmation passwordConfirmation =
    viewInput
        [ onInput OnPasswordConfirmationChange
        , placeholder "M1nh4S3nH4S3cr3T4!"
        , type_ "password"
        ]
        "Password Confirmation"
        passwordConfirmation


view : Model -> Shared -> Document Msg
view model _ =
    { title = "Welcome"
    , body =
        [ div
            [ class "h-screen w-screen flex flex-col justify-center items-center bg-sky-100"
            ]
            [ span
                [ class "text-center text-2xl text-sky-600" ]
                [ text "ShowMaker" ]
            , form
                [ class "flex flex-col justify-center items-center mt-20 px-12 py-12 bg-white shadow rounded-lg" ]
                [ viewEmail model.email
                , viewPassword model.password
                , viewPasswordConfirmation model.passwordConfirmation
                , button
                    [ class "mt-8 px-4 py-2 bg-sky-600 rounded-full text-white font-semibold"
                    ]
                    [ text "Register!" ]
                ]
            ]
        ]
    }
