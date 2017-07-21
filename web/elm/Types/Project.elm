module Types.Project exposing (..)

import Json.Encode as JE
import Json.Decode as JD exposing (..)
import Json.Decode.Extra as JD exposing (..)
import Types.Note exposing (Note, decodeNotes)


type alias Project =
    { id : Int
    , name : String
    , notes : List Note
    }


lookupProject : String -> List Project -> Maybe Project
lookupProject name projects =
    List.filter (\p -> p.name == name) projects
        |> List.head


addNotesToProject : Int -> List Note -> List Project -> List Project
addNotesToProject projectIdToUpdate notes projects =
    List.map
        (\p ->
            if p.id == projectIdToUpdate then
                { p | notes = notes }
            else
                p
        )
        projects


addNoteToProject : Int -> Note -> List Project -> List Project
addNoteToProject projectIdToUpdate note projects =
    List.map
        (\p ->
            if p.id == projectIdToUpdate then
                { p | notes = List.append p.notes [ note ] }
            else
                p
        )
        projects


decodeProjects : Decoder (List Project)
decodeProjects =
    JD.list decodeProject


decodeProject : Decoder Project
decodeProject =
    succeed Project
        |: (field "id" int)
        |: (field "name" string)
        |: (oneOf
                [ (field "notes" decodeNotes)
                , succeed []
                ]
           )


encodeNewProject : String -> JE.Value
encodeNewProject name =
    (JE.object
        [ ( "name", JE.string name )
        ]
    )
