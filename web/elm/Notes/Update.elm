module Notes.Update exposing (..)

import Notes.Models exposing (Model)
import Notes.Messages exposing (Msg(..), OutMsg(..))


update : Msg -> Model -> ( Model, Cmd Msg, Maybe OutMsg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none, Nothing )
