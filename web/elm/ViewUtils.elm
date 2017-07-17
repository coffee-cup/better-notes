module ViewUtils exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


headingHuge : String -> Html msg
headingHuge title =
    h1 [ class "f-huge f-subheadline-s mt6 mb4" ] [ text title ]


headingLarge : String -> Html msg
headingLarge title =
    h1 [ class "f-headline-ns f-subheadline-s f1 measure mv4" ] [ text title ]


headingSmall : String -> Html msg
headingSmall title =
    h2 [ class "f2 mv4" ] [ text title ]


heart : Html msg
heart =
    span [ class "text-accent" ] [ text "♥" ]


gutter : String
gutter =
    "ph6-ns ph4-m ph3"
