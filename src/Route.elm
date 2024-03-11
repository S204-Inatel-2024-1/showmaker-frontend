module Route exposing (Route(..), fromUrl, href, pushUrl, replaceUrl)

import Browser.Navigation as Nav
import Html exposing (Attribute)
import Html.Attributes as Attr
import Url exposing (Url)
import Url.Builder as B
import Url.Parser as P exposing ((</>))


type
    Route
    -- = Home
    = Welcome


routeParser : P.Parser (Route -> a) a
routeParser =
    P.oneOf
        -- [ P.map Home P.top
        [ P.map Welcome (P.s "welcome")
        ]



-- PUBLIC HELPERS


href : Route -> Attribute msg
href targetRoute =
    Attr.href (routeToString targetRoute)


replaceUrl : Nav.Key -> Route -> Cmd msg
replaceUrl key route =
    Nav.replaceUrl key (routeToString route)


fromUrl : Url -> Maybe Route
fromUrl url =
    P.parse routeParser url


pushUrl : Nav.Key -> Route -> Cmd msg
pushUrl key route =
    Nav.pushUrl key (routeToString route)


routeToString : Route -> String
routeToString route =
    let
        ( paths, queries ) =
            case route of
                --            Home ->
                --              ( [], [] )
                Welcome ->
                    ( [], [] )
    in
    B.absolute paths queries
