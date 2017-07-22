module Notes.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, placeholder)
import Html.Events exposing (onInput, onSubmit)
import Types.Project exposing (Project)
import Types.Note exposing (Note)
import Notes.Models exposing (Model)
import Notes.Messages exposing (..)
import ViewUtils exposing (..)


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
        div [ class "notes-header bg-primary text-light ph4 pv3" ]
            [ sidebarToggle ToggleSidebar
            , h1 [ class "f3 mv0" ] [ text projectName ]
            ]


notesContent : Project -> Model -> Html Msg
notesContent project model =
    div [ class "notes-content flex col sb" ]
        [ notesList project.notes
        , messageBox model.noteText
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


notesList : List Note -> Html Msg
notesList notes =
    let
        notesView =
            case notes of
                [] ->
                    emptyNotesList

                _ ->
                    populatedNotesList notes
    in
        div [ class "notes-list-wrapper" ]
            [ div [ class "notes-list measure-wide lh-copy pa4 fg1" ]
                [ notesView
                ]
            ]


emptyNotesList : Html Msg
emptyNotesList =
    div [ class "notes-list-empty vertical-center" ]
        [ h2 [] [ text "You have no notes..." ] ]


populatedNotesList : List Note -> Html Msg
populatedNotesList notes =
    div []
        (List.map noteView notes)


noteView : Note -> Html Msg
noteView note =
    div [ class "note pv2" ]
        [ text note.text ]


messageBox : String -> Html Msg
messageBox noteText =
    div [ class "notes-messageBox" ]
        [ form [ onSubmit (CreateNote noteText), class "fg1 h-100 flex col" ]
            [ textarea
                [ placeholder "Write anything..."
                , class "w-100 h-100 pa4 mono"
                , onInput ChangeNoteText
                ]
                [ text noteText
                ]
            , button [ class "button button--noRadius" ] [ text "Create!" ]
            ]
        ]
