module Messages exposing (..)

import Phoenix.Socket
import Navigation exposing (Location)
import Json.Encode as JE
import Http
import Types.User exposing (User)
import Types.Project exposing (Project)
import Chat.Messages
import Notes.Messages
import Sidebar.Messages


type Msg
    = OnLocationChange Location
    | OnFetchText (Result Http.Error String)
    | ChatMsg Chat.Messages.Msg
    | NotesMsg Notes.Messages.Msg
    | SidebarMsg Sidebar.Messages.Msg
    | JoinChannel
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveChatMessage JE.Value
    | ShowHome
    | ShowAbout
    | OnFetchLogin (Result Http.Error String)
    | OnFetchUser (Result Http.Error User)
    | OnFetchProjects (Result Http.Error (List Project))
    | OnCreateProject (Result Http.Error Project)
    | OnDeleteProject (Result Http.Error Int)
