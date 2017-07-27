module Notes.Messages exposing (..)

import Types.Note exposing (Note)


type Msg
    = ToggleSidebar
    | ClearNoteText
    | ChangeNoteText String
    | CreateNote String
    | DeleteNote Note
