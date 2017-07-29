module Messages exposing (..)

import Navigation exposing (Location)
import Http
import Types.User exposing (User)
import Types.Project exposing (Project)
import Types.Note exposing (Note)
import Notes.Messages
import Sidebar.Messages


type Msg
    = OnLocationChange Location
    | NotesMsg Notes.Messages.Msg
    | SidebarMsg Sidebar.Messages.Msg
    | ShowHome
    | ShowAbout
    | OnFetchLogin (Result Http.Error String)
    | OnFetchUser (Result Http.Error User)
    | OnFetchProjects (Result Http.Error (List Project))
    | OnCreateProject (Result Http.Error Project)
    | OnDeleteProject (Result Http.Error Int)
    | OnFetchNotes (Result Http.Error (List Note))
    | OnCreateNote (Result Http.Error Note)
    | OnDeleteNote (Result Http.Error ( Int, Int ))
