module Sidebar.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (value, placeholder, class, classList)
import Html.Events exposing (onClick, onInput, onSubmit)
import Types.Project exposing (Project)
import Sidebar.Messages exposing (Msg(..))
import Sidebar.Models exposing (Model)


view : List Project -> Maybe Project -> Model -> Html Msg
view projects maybeSelectedProject model =
    div [ class "sidebar pv4 flex col" ]
        [ h1 [ class "f3 mv2 bold" ] [ text "Better Notes" ]
        , projectList projects maybeSelectedProject
        , createProject model.newProjectName
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
        div [ class "project-list fg1 mt4" ]
            ([ p [ class "f6 o-50" ] [ text "projects" ] ]
                ++ (List.map (\p -> projectView p (p.name == selectedProjectName)) projects)
            )


projectView : Project -> Bool -> Html Msg
projectView project selected =
    div [ classList [ ( "project", True ), ( "selected", selected ) ] ]
        [ p [ class "flex" ]
            [ span [ onClick (SelectProject project), class "fg1 dim pointer" ] [ text project.name ]
            , span [ onClick (DeleteProject project), class "project-delete pr2 f6 pointer" ] [ text "♻️" ]
            ]
        ]


createProject : String -> Html Msg
createProject projectName =
    div [ class "create-project" ]
        [ form [ onSubmit (CreateProject projectName), class "flex" ]
            [ input
                [ placeholder "Project name"
                , onInput SetNewProjectName
                , value projectName
                , class "bnone"
                ]
                []
            , button [ class "button" ] [ text "Create" ]
            ]
        ]
