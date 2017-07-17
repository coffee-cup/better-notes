module Sidebar.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Messages exposing (Msg(..))
import Sidebar.Models exposing (Model)


view : Model -> Html Msg
view model =
    div [ class "sidebar" ]
        [ h1 [ class "f3 bold" ] [ text "Better Notes" ]
        ]
