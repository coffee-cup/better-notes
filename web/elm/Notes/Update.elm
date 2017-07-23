module Notes.Update exposing (..)

import Notes.Models exposing (Model)
import Notes.Messages exposing (Msg(..))


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeNoteText text ->
            ( { model | noteText = text }, Cmd.none )

        ClearNoteText ->
            ( { model | noteText = "" }, Cmd.none )

        _ ->
            ( model, Cmd.none )
