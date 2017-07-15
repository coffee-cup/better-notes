module Main exposing (..)

import Task
import Navigation exposing (Location)
import Debug
import Flags exposing (Flags)
import Models exposing (Model, initialModel)
import Messages exposing (Msg(..))
import Subscriptions exposing (subscriptions)
import Commands exposing (getText, loginFromCode)
import View exposing (view)
import Update exposing (update, pageView)
import Routing
import Auth


-- Init


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute =
            Routing.parseLocation location

        loginCommand =
            getLoginCommand location

        commands =
            loginCommand :: [ getText ]
    in
        ( initialModel flags currentRoute
        , Cmd.batch commands
        )



-- Main


main : Program Flags Model Msg
main =
    Navigation.programWithFlags OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


getLoginCommand : Location -> Cmd Msg
getLoginCommand loc =
    case Auth.parseCodeFromQuery loc of
        Just code ->
            loginFromCode code

        Nothing ->
            Cmd.none
