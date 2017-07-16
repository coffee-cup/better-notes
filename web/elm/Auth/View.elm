module Auth.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Models exposing (Model)
import Messages exposing (Msg(..))
import ViewUtils exposing (..)
import Auth


view : Model -> Html Msg
view model =
    div [ class "auth" ]
        [ headingHuge "Auth" ]


viewLogin : Model -> Html Msg
viewLogin model =
    div [ class "login" ]
        [ a [ href Auth.googleAuthUrl, class "button mv2" ]
            [ text "Login with Google" ]
        ]
