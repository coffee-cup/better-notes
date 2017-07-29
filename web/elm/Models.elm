module Models exposing (..)

import Routing exposing (Sitemap)
import Flags exposing (Flags)
import Types.User exposing (User)
import Types.Project exposing (Project)
import Notes.Models
import Sidebar.Models


type alias Model =
    { text : String
    , username : String
    , error : String
    , notesModel : Notes.Models.Model
    , sidebarModel : Sidebar.Models.Model
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
    , notesModel = Notes.Models.initialModel
    , sidebarModel = Sidebar.Models.initialModel
    , user = Nothing
    , projects = []
    , selectedProject = Nothing
    , token = flags.token
    , sidebarOpen = not flags.onMobile
    , route = sitemap
    , flags = flags
    }
