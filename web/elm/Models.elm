module Models exposing (..)

import Routing exposing (Sitemap)
import Phoenix.Socket exposing (Socket)
import Flags exposing (Flags)
import Sockets exposing (initPhxSocket)
import Messages exposing (Msg(..))
import Chat.Models


type alias Model =
    { text : String
    , username : String
    , error : String
    , chatModel : Chat.Models.Model
    , phxSocket : Phoenix.Socket.Socket Msg
    , route : Sitemap
    , flags : Flags
    }


initialModel : Flags -> Sitemap -> Model
initialModel flags sitemap =
    { text = ""
    , username = ""
    , error = "shit"
    , chatModel = Chat.Models.initialModel
    , phxSocket = initPhxSocket flags
    , route = sitemap
    , flags = flags
    }
