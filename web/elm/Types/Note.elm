module Types.Note exposing (..)

import Json.Encode as JE
import Json.Decode as JD exposing (..)
import Json.Decode.Extra as JD exposing (..)


type alias Note =
    { id : Int
    , projectId : Int
    , text : String
    }


decodeNotes : Decoder (List Note)
decodeNotes =
    JD.list decodeNote


decodeNote : Decoder Note
decodeNote =
    succeed Note
        |: (field "id" int)
        |: (field "project_id" int)
        |: (field "text" string)


encodeNewNote : String -> Int -> JE.Value
encodeNewNote text projectId =
    (JE.object
        [ ( "text", JE.string text )
        ]
    )
