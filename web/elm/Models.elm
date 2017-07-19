module Models exposing (..)

import Routing exposing (Sitemap)
import Phoenix.Socket exposing (Socket)
import Flags exposing (Flags)
import Sockets exposing (initPhxSocket)
import Messages exposing (Msg(..))
import Types.User exposing (User)
import Types.Project exposing (Project)
import Chat.Models
import Notes.Models
import Sidebar.Models


type alias Model =
    { text : String
    , username : String
    , error : String
    , chatModel : Chat.Models.Model
    , notesModel : Notes.Models.Model
    , sidebarModel : Sidebar.Models.Model
    , phxSocket : Phoenix.Socket.Socket Msg
    , user : Maybe User
    , projects : List Project
    , selectedProject : Maybe Project
    , token : String
    , sidebarOpen : Bool
    , route : Sitemap
    , flags : Flags
    }


initialModel : Flags -> Sitemap -> Model
initialModel flags sitemap =
    { text = ""
    , username = ""
    , error = ""
    , chatModel = Chat.Models.initialModel
    , notesModel = Notes.Models.initialModel
    , sidebarModel = Sidebar.Models.initialModel
    , phxSocket = initPhxSocket flags
    , user = Nothing
    , projects = []
    , selectedProject = Nothing
    , token = flags.token
    , sidebarOpen = not flags.onMobile
    , route = sitemap
    , flags = flags
    }
