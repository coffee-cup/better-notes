module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href, classList)
import Html.Events exposing (onClick)
import Messages exposing (Msg(..))
import Models exposing (Model)
import Routing exposing (Sitemap(..))
import ViewUtils exposing (..)
import Auth.View
import Notes.View
import Sidebar.View


view : Model -> Html Msg
view model =
    div [ class "app" ]
        [ div [] [ page model ]
        ]


page : Model -> Html Msg
page model =
    case model.route of
        HomeRoute ->
            homeView model

        AuthRoute ->
            Auth.View.view model

        NotesRoute ->
            notesView model

        NotesProjectRoute name ->
            notesView model

        AboutRoute ->
            aboutView model

        NotFoundRoute ->
            notFoundView


apiText : Model -> Html Msg
apiText model =
    div []
        [ p [ class "measure" ]
            [ span [ class "text-secondary pr2" ] [ text "from api" ]
            , span [] [ text model.text ]
            ]
        ]


footer : Html Msg
footer =
    div [ class "footer pv4" ]
        [ p [ class "f5" ]
            [ a [ onClick ShowHome, class "dim none pointer" ]
                [ heart
                , text " from jake."
                ]
            ]
        ]



-- Routes


homeView : Model -> Html Msg
homeView model =
    div [ class ("home flex jc ac col full") ]
        [ div [ class "box flex col ph5-ns ph4 pv4" ]
            [ h1 [ class "f-headline-ns f-subheadline mv0" ] [ text "Better" ]
            , h1 [ class "f-headline-ns f-subheadline mv0" ] [ text "Notes" ]
            , p [] [ text "Talk to yourself note taking." ]
            , Auth.View.viewLogin model

            --, Html.map ChatMsg (Chat.View.view model.chatModel)
            ]
        ]


notesView : Model -> Html Msg
notesView model =
    div [ classList [ ( "notes-page full", True ), ( "sidebar-open", model.sidebarOpen ) ] ]
        [ Html.map SidebarMsg (Sidebar.View.view model.projects model.selectedProject model.sidebarModel)
        , Html.map NotesMsg (Notes.View.view model.selectedProject model.notesModel)
        ]


aboutView : Model -> Html Msg
aboutView model =
    div [ class "about flex sb col full" ]
        [ div []
            [ headingLarge "About"
            , p [ class "measure" ] [ text "About this site." ]
            , a [ onClick ShowHome, class "f1 none dim" ] [ text "←" ]
            ]
        ]


notFoundView : Html Msg
notFoundView =
    div [ class "not-found full vertical-center" ]
        [ div []
            [ h2 [ class "f2 mv4 mono" ] [ text "¯\\_(ツ)_/¯" ]
            , p [ class "measure" ]
                [ text "Page not found. "
                , a [ onClick ShowHome, class "pointer su-colour" ] [ text "Go home" ]
                , text "."
                ]
            ]
        ]
