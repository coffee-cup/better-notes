module Notes.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, placeholder, property)
import Html.Events exposing (onInput, onSubmit)
import Ace
import Json.Encode as JE
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
            [ div [ class "notes-list lh-copy mh4 fg1" ]
                [ notesView
                ]
            ]


emptyNotesList : Html Msg
emptyNotesList =
    div [ class "notes-list-empty vertical-center" ]
        [ h2 [] [ text "You have no notes..." ] ]


populatedNotesList : List Note -> Html Msg
populatedNotesList notes =
    div [ class "markdown" ]
        (List.map noteView notes)


noteView : Note -> Html Msg
noteView note =
    div [ class "note", property "innerHTML" (JE.string note.html) ]
        []


messageBox : String -> Html Msg
messageBox noteText =
    div [ class "notes-messageBox" ]
        [ form [ onSubmit (CreateNote noteText), class "fg1 h-100 flex" ]
            [ Ace.toHtml
                [ Ace.theme "tomorrow_night_eighties"
                , Ace.mode "markdown"
                , Ace.showGutter False
                , Ace.highlightActiveLine False
                , Ace.useSoftTabs True
                , Ace.enableBasicAutocompletion True
                , Ace.enableLiveAutocompletion True
                , Ace.enableSnippets True
                , Ace.extensions [ "language_tools", "static_highlight", "spellcheck" ]
                , Ace.onSourceChange ChangeNoteText
                , Ace.onShiftEnter (CreateNote noteText)
                , Ace.value noteText
                ]
                []
            , button
                [ class "notes-createButton button button--noRadius button--greenHover"
                ]
                [ text "Create!" ]
            ]
        ]
