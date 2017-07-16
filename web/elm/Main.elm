module Main exposing (..)

import Navigation exposing (Location)
import Flags exposing (Flags)
import Models exposing (Model, initialModel)
import Messages exposing (Msg(..))
import Subscriptions exposing (subscriptions)
import Commands exposing (getText, getLoginCommand, getUserCommand)
import View exposing (view)
import Update exposing (update, pageView)
import Routing exposing (Sitemap(..))


-- Init


init : Flags -> Location -> ( Model, Cmd Msg )
init flags location =
    let
        currentRoute =
            Routing.parseLocation location

        loginCommand =
            getLoginCommand location

        userCommand =
            getUserCommand location flags

        commands =
            loginCommand :: userCommand :: [ getText ]
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
