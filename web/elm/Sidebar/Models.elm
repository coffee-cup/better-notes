module Sidebar.Models exposing (..)


type alias Model =
    { newProjectName : String
    }


initialModel : Model
initialModel =
    { newProjectName = ""
    }
