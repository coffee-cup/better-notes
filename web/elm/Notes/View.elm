module Notes.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, placeholder, property)
import Html.Events exposing (onInput, onSubmit, onClick)
import Html.Keyed as Keyed
import Html.Lazy exposing (lazy)
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
        div [ class "notes-header ph4-ns ph2 pv2" ]
            [ sidebarToggle ToggleSidebar
            , div [ class "cont" ]
                [-- p [ class "f4 mv0 mono" ] [ text ("/" ++ projectName) ]
                ]
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
        [ div [ class "mh4-ns mh2" ]
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
            [ div [ class "notes-list lh-copy mh4-ns mh2 fg1" ]
                [ notesView
                ]
            ]


emptyNotesList : Html Msg
emptyNotesList =
    div [ class "notes-list-empty cont" ]
        [ h2 [] [ text "You have no notes 😞" ] ]


populatedNotesList : List Note -> Html Msg
populatedNotesList notes =
    Keyed.node "div"
        [ class "markdown cont" ]
        (List.map keyedNoteView notes)


keyedNoteView : Note -> ( String, Html Msg )
keyedNoteView note =
    ( toString note.id, lazy noteView note )


noteView : Note -> Html Msg
noteView note =
    div [ class "note", property "innerHTML" (JE.string note.html) ]
        [ span [ onClick (DeleteNote note), class "note-delete" ] [ text "♻️" ] ]


messageBox : String -> Html Msg
messageBox noteText =
    div [ class "notes-messageBox" ]
        [ form [ onSubmit (CreateNote noteText), class "fg1 h-100 flex cont" ]
            [ div [ class "notes-editor fg1 relative" ]
                [ Ace.toHtml
                    [ Ace.theme "github"
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
                , span [ class "notes-editor-hint" ]
                    [ text "shift+enter to create" ]
                ]
            ]
        ]
