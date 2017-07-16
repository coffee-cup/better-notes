module Notes.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Models exposing (Model)
import Messages exposing (Msg(..))
import Types exposing (User)
import ViewUtils exposing (..)


view : Model -> Html Msg
view model =
    div [ class "notes" ]
        [ headingHuge "Notes"
        , viewUser model.user
        ]


viewUser : Maybe User -> Html Msg
viewUser maybeUser =
    case maybeUser of
        Just user ->
            div [ class "user" ]
                [ img [ src user.avatar ] []
                , p [] [ text (user.firstName ++ " " ++ user.lastName) ]
                , p [] [ text user.email ]
                ]

        Nothing ->
            div [ class "user" ] [ text "No user" ]
