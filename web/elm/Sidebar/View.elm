module Sidebar.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (value, placeholder, class, classList)
import Html.Events exposing (onClick, onInput, onSubmit)
import Types.Project exposing (Project)
import Sidebar.Messages exposing (Msg(..))
import Sidebar.Models exposing (Model)
import ViewUtils exposing (..)


view : List Project -> Maybe Project -> Model -> Html Msg
view projects maybeSelectedProject model =
    div [ class "sidebar pv4 flex col" ]
        [ header
        , projectList projects maybeSelectedProject
        , createProject model.newProjectName
        ]


header : Html Msg
header =
    div [ class "sidebar-header" ]
        [ sidebarToggle ToggleSidebar
        ]


projectList : List Project -> Maybe Project -> Html Msg
projectList projects maybeSelectedProject =
    let
        selectedProjectName =
            case maybeSelectedProject of
                Just project ->
                    project.name

                Nothing ->
                    ""
    in
        div [ class "project-list fg1 flex col jc mt0 ph4" ]
            [ div []
                ([ p [ class "f5 mono" ] [ text "projects" ] ]
                    ++ (List.map (\p -> projectView p (p.name == selectedProjectName)) projects)
                )
            ]


projectView : Project -> Bool -> Html Msg
projectView project selected =
    div [ classList [ ( "project", True ), ( "selected", selected ) ] ]
        [ p [ class "flex" ]
            [ span [ onClick (SelectProject project), class "fg1 dim pointer b" ] [ text project.name ]
            , span [ onClick (DeleteProject project), class "project-delete pr2 f6 pointer" ] [ text "♻️" ]
            ]
        ]


createProject : String -> Html Msg
createProject projectName =
    div [ class "create-project ph2" ]
        [ form [ onSubmit (CreateProject projectName), class "flex" ]
            [ input
                [ placeholder "Project name"
                , onInput SetNewProjectName
                , value projectName
                , class "f6 mono"
                ]
                []
            , button [ class "button" ] [ text "Create" ]
            ]
        ]
