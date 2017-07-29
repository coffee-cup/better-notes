module Auth.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href)
import Models exposing (Model)
import Messages exposing (Msg(..))
import Auth


view : Model -> Html Msg
view model =
    div [ class "auth" ]
        []


viewLogin : Model -> Html Msg
viewLogin model =
    div [ class "login flex jc" ]
        [ a [ href Auth.googleAuthUrl, class "button button--large w-100 tc mv2" ]
            [ text "Take off with Google 🚀" ]
        ]
