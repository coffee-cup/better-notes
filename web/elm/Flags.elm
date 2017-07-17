module Flags exposing (Flags)


type alias Flags =
    { prod : Bool
    , websocketUrl : String
    , token : String
    , onMobile : Bool
    }
