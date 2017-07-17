module Sidebar.View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (value, placeholder, class)
import Html.Events exposing (onClick, onInput, onSubmit)
import Sidebar.Messages exposing (Msg(..))
import Sidebar.Models exposing (Model)


view : Model -> Html Msg
view model =
    div [ class "sidebar pv4 flex col" ]
        [ h1 [ class "f3 mt4 bold" ] [ text "Better Notes" ]
        , projectList
        , createProject model.projectName
        ]


projectList : Html Msg
projectList =
    div [ class "project-list fg1" ]
        []


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
            , button [ onClick (CreateProject projectName), class "button" ] [ text "Create" ]
            ]
        ]
