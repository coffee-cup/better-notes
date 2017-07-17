module Sidebar exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Messages exposing (Msg(..))
import Models exposing (Model)


view : Model -> Html Msg
view model =
    div [ class "sidebar" ]
        [ h2 []
            [ text "This is the sidebar!" ]
        ]
