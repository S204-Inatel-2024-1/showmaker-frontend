module Main exposing (main)

import Browser exposing (Document)
import Browser.Navigation as Nav
import Flags exposing (Flags)
import Html
import Json.Decode as D
import Pages.Home as Home
import Pages.Welcome as Welcome
import Route exposing (Route)
import Shared exposing (Shared)
import Url


type alias Model =
    { pageModel : PageModel
    , shared : Maybe Shared
    }


type PageModel
    = Error404Model
    | HomeModel Home.Model
    | WelcomeModel Welcome.Model


type Msg
    = GotHomeMsg Home.Msg
    | GotWelcomeMsg Welcome.Msg
    | UrlChanged Url.Url
    | UrlRequested Browser.UrlRequest


init : D.Value -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init jsonFlags url navKey =
    case D.decodeValue Flags.decode jsonFlags of
        Err _ ->
            changeRouteTo (Route.fromUrl url)
                { pageModel = Error404Model
                , shared = Nothing
                }

        Ok flags ->
            changeRouteTo (Route.fromUrl url)
                { pageModel = WelcomeModel Welcome.defaultModel
                , shared = toShared navKey flags
                }


toShared : Nav.Key -> Flags -> Maybe Shared
toShared navKey flags =
    Just
        { navKey = navKey
        , flags = flags
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case ( msg, model.pageModel, model.shared ) of
        ( GotHomeMsg homeMsg, HomeModel homeModel, Just shared ) ->
            let
                ( pageModel, pageCmd ) =
                    Home.update homeMsg homeModel shared
            in
            ( { model | pageModel = HomeModel pageModel, shared = Just shared }, Cmd.map GotHomeMsg pageCmd )

        ( GotWelcomeMsg welcomeMsg, WelcomeModel welcomeModel, Just shared ) ->
            let
                ( pageModel, pageCmd ) =
                    Welcome.update welcomeMsg welcomeModel shared
            in
            ( { model | pageModel = WelcomeModel pageModel, shared = Just shared }, Cmd.map GotWelcomeMsg pageCmd )

        ( UrlChanged url, _, _ ) ->
            changeRouteTo (Route.fromUrl url) model

        ( UrlRequested urlRequest, _, Just shared ) ->
            case urlRequest of
                Browser.Internal url ->
                    ( model
                    , Nav.pushUrl shared.navKey (Url.toString url)
                    )

                Browser.External href ->
                    ( model
                    , Nav.load href
                    )

        _ ->
            ( model, Cmd.none )


changeRouteTo : Maybe Route -> Model -> ( Model, Cmd Msg )
changeRouteTo maybeRoute model =
    case ( maybeRoute, model.shared ) of
        ( Just route, Just shared ) ->
            ( model, Route.replaceUrl shared.navKey route )

        _ ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none


view : Model -> Document Msg
view model =
    case ( model.pageModel, model.shared ) of
        ( HomeModel homeModel, Just shared ) ->
            let
                document =
                    Home.view homeModel shared

                body =
                    document.body
                        |> List.map (\html -> Html.map GotHomeMsg html)
            in
            { title = document.title
            , body = body
            }

        ( WelcomeModel welcomeModel, Just shared ) ->
            let
                document =
                    Welcome.view welcomeModel shared

                body =
                    document.body
                        |> List.map (\html -> Html.map GotWelcomeMsg html)
            in
            { title = document.title
            , body = body
            }

        _ ->
            { title = "Error"
            , body = []
            }


main : Program D.Value Model Msg
main =
    Browser.application
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = UrlRequested
        }
