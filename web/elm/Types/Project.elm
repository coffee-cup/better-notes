module Types.Project exposing (..)

import Json.Encode as JE
import Json.Decode as JD exposing (..)
import Json.Decode.Extra as JD exposing (..)


type alias Project =
    { id : Int
    , name : String
    }


decodeProjects : Decoder (List Project)
decodeProjects =
    JD.list decodeProject


decodeProject : Decoder Project
decodeProject =
    succeed Project
        |: (field "id" int)
        |: (field "name" string)


encodeNewProject : String -> JE.Value
encodeNewProject name =
    (JE.object
        [ ( "name", JE.string name )
        ]
    )
