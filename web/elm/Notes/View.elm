module Notes.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import ViewUtils exposing (..)
import Notes.Models exposing (Model)
import Notes.Messages exposing (..)


view : Model -> Html Msg
view model =
    div [ class "notes" ]
        [ headingHuge "Notes"
        ]



--viewUser : Maybe User -> Html Msg
--viewUser maybeUser =
--    case maybeUser of
--        Just user ->
--            div [ class "user" ]
--                [ img [ src user.avatar ] []
--                , p [] [ text (toString user.id) ]
--                , p [] [ text (user.firstName ++ " " ++ user.lastName) ]
--                , p [] [ text user.email ]
--                ]
--        Nothing ->
--            div [ class "user" ] [ text "No user" ]
