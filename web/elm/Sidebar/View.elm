module Sidebar.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (value, placeholder, class)
import Html.Events exposing (onClick, onInput, onSubmit)
import Types.Project exposing (Project)
import Sidebar.Messages exposing (Msg(..))
import Sidebar.Models exposing (Model)


view : List Project -> Maybe Project -> Model -> Html Msg
view projects maybeSelectedProject model =
    div [ class "sidebar pv4 flex col" ]
        [ h1 [ class "f3 mv2 bold" ] [ text "Better Notes" ]
        , projectList projects
        , createProject model.newProjectName
        ]


projectList : List Project -> Html Msg
projectList projects =
    div [ class "project-list fg1 mt4" ]
        ([ p [ class "f6 o-50" ] [ text "projects" ] ]
            ++ (List.map projectView projects)
        )


projectView : Project -> Html Msg
projectView project =
    div [ class "project" ]
        [ p [ class "flex" ]
            [ span [ class "fg1 dim pointer" ] [ text project.name ]
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
