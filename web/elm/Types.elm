module Types exposing (..)


type alias Message =
    { user : String
    , body : String
    }


type alias User =
    { id : Int
    , firstName : String
    , lastName : String
    , avatar : Image
    , email : String
    }


type alias Image =
    String


type alias Email =
    String
