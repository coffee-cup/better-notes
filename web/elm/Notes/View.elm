module Notes.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Notes.Models exposing (Model)
import Notes.Messages exposing (..)


view : Model -> Html Msg
view model =
    div [ class "notes" ]
        [ header model
        , content model
        ]


header : Model -> Html Msg
header model =
    div [ class "notes-header bg-primary text-light ph3 pv4" ]
        [ span [ class "toggle-sidebar", onClick ToggleSidebarPressed ] [ text "X" ]
        , h1 [ class "f3" ] [ text "Project Name" ]
        ]


content : Model -> Html Msg
content model =
    div [ class "notes-content flex col" ]
        [ notesList model
        , messageBox model
        ]


notesList : Model -> Html Msg
notesList model =
    div [ class "notes-list pa4 fg1" ]
        [ h2 [] [ text "this is where the notes go." ]
        ]


messageBox : Model -> Html Msg
messageBox model =
    div [ class "notes-messageBox" ]
        [ textarea [ placeholder "Write anything...", class "w-100 h-100 pa4" ] [] ]



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
