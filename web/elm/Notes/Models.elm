module Notes.Models exposing (..)


type alias Model =
    { noteText : String
    , shiftDown : Bool
    }


initialModel : Model
initialModel =
    { noteText = ""
    , shiftDown = False
    }
