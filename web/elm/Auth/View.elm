module Auth.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class)
import Models exposing (Model)
import Messages exposing (Msg(..))
import ViewUtils exposing (..)


view : Model -> Html Msg
view model =
    div [ class "auth" ]
        [ headingHuge "Auth" ]
