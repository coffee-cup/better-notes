module Commands exposing (..)

import Http
import Json.Decode as Decode exposing (field)
import Messages exposing (Msg(..))
import Api exposing (apiUrl)


getText : Cmd Msg
getText =
    Http.get "/api/" decodeTextUrl
        |> Http.send OnFetchText


loginFromCode : String -> Cmd Msg
loginFromCode code =
    Http.get (apiUrl "/auth/google/callback?code=" ++ code) decodeUser
        |> Http.send OnFetchLogin


decodeTextUrl : Decode.Decoder String
decodeTextUrl =
    field "hello" Decode.string


decodeUser : Decode.Decoder String
decodeUser =
    field "access_token" Decode.string
