module Sidebar.Update exposing (..)

import Sidebar.Models exposing (Model)
import Sidebar.Messages exposing (Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetNewProjectName string ->
            ( { model | projectName = string }, Cmd.none )

        ReceiveProjects projects ->
            ( { model | projects = projects }, Cmd.none )

        _ ->
            ( model, Cmd.none )
