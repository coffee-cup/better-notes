module Commands exposing (..)

import Json.Decode as Decode exposing (field)
import Navigation exposing (Location)
import Messages exposing (Msg(..))
import Api exposing (..)
import Auth
import Flags exposing (Flags)
import Routing exposing (Sitemap(..))


getLoginCommand : Location -> Cmd Msg
getLoginCommand loc =
    case Auth.parseCodeFromQuery loc of
        Just code ->
            loginFromCode code

        Nothing ->
            Cmd.none


getUserCommand : Location -> Flags -> Cmd Msg
getUserCommand loc flags =
    case Routing.parseLocation loc of
        HomeRoute ->
            Cmd.none

        AboutRoute ->
            Cmd.none

        AuthRoute ->
            Cmd.none

        NotFoundRoute ->
            Cmd.none

        _ ->
            getCurrentUser flags.token


decodeTextUrl : Decode.Decoder String
decodeTextUrl =
    field "hello" Decode.string
