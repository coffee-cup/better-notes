module Notes.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Types.Project exposing (Project)
import Notes.Models exposing (Model)
import Notes.Messages exposing (..)


view : Maybe Project -> Model -> Html Msg
view maybeSelectedProject model =
    let
        contentView =
            case maybeSelectedProject of
                Just project ->
                    notesContent project model

                Nothing ->
                    emptyContent
    in
        div [ class "notes" ]
            [ header maybeSelectedProject
            , contentView
            ]


header : Maybe Project -> Html Msg
header maybeSelectedProject =
    let
        projectName =
            case maybeSelectedProject of
                Just project ->
                    project.name

                Nothing ->
                    ""
    in
        div [ class "notes-header bg-primary text-light ph3 pv3" ]
            [ span [ class "toggle-sidebar", onClick ToggleSidebar ] [ text "X" ]
            , h1 [ class "f3 mv0" ] [ text projectName ]
            ]


notesContent : Project -> Model -> Html Msg
notesContent project model =
    div [ class "notes-content flex col" ]
        [ notesList model
        , messageBox model
        ]


emptyContent : Html Msg
emptyContent =
    div [ class "notes-content vertical-center" ]
        [ div []
            [ h2 [ class "f1 mv0" ]
                [ text "No Project Selected" ]
            , p [] [ text "Select or create a project from the sidebar." ]
            ]
        ]


notesList : Model -> Html Msg
notesList model =
    div [ class "notes-list pa4 fg1" ]
        [ h2 []
            [ text "this is where the notes go."
            ]
        ]


messageBox : Model -> Html Msg
messageBox model =
    div [ class "notes-messageBox" ]
        [ textarea [ placeholder "Write anything...", class "w-100 h-100 pa4" ] [] ]
