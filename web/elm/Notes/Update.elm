module Notes.Update exposing (..)

import Notes.Models exposing (Model)
import Notes.Messages exposing (Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        _ ->
            ( model, Cmd.none )
