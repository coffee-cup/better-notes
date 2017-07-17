module Sidebar.Models exposing (..)


type alias Model =
    { projectName : String
    }


initialModel : Model
initialModel =
    { projectName = ""
    }
