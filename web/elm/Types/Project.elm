module Types.Project exposing (..)

import Json.Decode as Decode exposing (..)
import Json.Decode.Extra as Decode exposing (..)


type alias Project =
    { id : Int
    , name : String
    }


decodeProjects : Decoder (List Project)
decodeProjects =
    Decode.list decodeProject


decodeProject : Decoder Project
decodeProject =
    succeed Project
        |: (field "id" int)
        |: (field "name" string)
