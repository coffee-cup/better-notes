module Messages exposing (..)

import Phoenix.Socket
import Navigation exposing (Location)
import Json.Encode as JE
import Http
import Chat.Messages
import Notes.Messages
import User exposing (User)


type Msg
    = OnLocationChange Location
    | OnFetchText (Result Http.Error String)
    | ChatMsg Chat.Messages.Msg
    | NotesMsg Notes.Messages.Msg
    | JoinChannel
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveChatMessage JE.Value
    | ToggleSidebar
    | ShowHome
    | ShowAbout
    | OnFetchLogin (Result Http.Error String)
    | OnFetchUser (Result Http.Error User)
