module Shared exposing (Shared)

import Browser.Navigation as Nav
import Flags exposing (Flags)


type alias Shared =
    { flags : Flags
    , navKey : Nav.Key
    }
