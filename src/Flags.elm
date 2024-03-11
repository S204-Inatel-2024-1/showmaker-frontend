module Flags exposing (Flags, decode)

import Json.Decode as D exposing (Decoder)
import Json.Decode.Pipeline as P


type alias Flags =
    { baseUrl : String
    }


decode : Decoder Flags
decode =
    D.succeed Flags
        |> P.required "baseUrl" D.string
