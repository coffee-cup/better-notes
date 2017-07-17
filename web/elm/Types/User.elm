module Types.User exposing (..)

import Json.Decode as Decode exposing (..)
import Json.Decode.Extra as Decode exposing (..)


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


decodeUser : Decoder User
decodeUser =
    succeed User
        |: (field "id" int)
        |: (field "first_name" string)
        |: (field "last_name" string)
        |: (field "avatar" string)
        |: (field "email" string)
