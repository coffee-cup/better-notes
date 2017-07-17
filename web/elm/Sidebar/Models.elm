module Sidebar.Models exposing (..)

import Types.Project exposing (Project)


type alias Model =
    { projectName : String
    , projects : List Project
    }


initialModel : Model
initialModel =
    { projectName = ""
    , projects = []
    }
