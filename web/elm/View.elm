module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (class, href, classList)
import Html.Events exposing (onClick)
import Messages exposing (Msg(..))
import Models exposing (Model)
import Routing exposing (Sitemap(..))
import ViewUtils exposing (..)
import Chat.View


view : Model -> Html Msg
view model =
    div [ class "ph6-ns ph4-m ph3" ]
        [ div [] [ page model ]
        , footer
        ]



-- Router


page : Model -> Html Msg
page model =
    case model.route of
        HomeRoute ->
            homeView model

        AboutRoute ->
            aboutView model

        NotFoundRoute ->
            notFoundView


header : Model -> Html Msg
header model =
    div [ class "header bold" ]
        [ div []
            [ headingHuge "Better Notes"
            ]
        ]


login : Html Msg
login =
    div [ class "login" ]
        [ button [ onClick Login, class "button mv4" ]
            [ text "Login with Google"
            ]
        ]


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
    div [ class "home col full" ]
        [ header model
        , login

        --, Html.map ChatMsg (Chat.View.view model.chatModel)
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
