module Routing exposing (..)

import Navigation exposing (Location)
import Route exposing (..)


type Sitemap
    = HomeRoute
    | AboutRoute
    | AuthRoute
    | NotesRoute
    | NotesProjectRoute String
    | NotFoundRoute


homeR : Route.Route Sitemap
homeR =
    HomeRoute := static ""


aboutR : Route.Route Sitemap
aboutR =
    AboutRoute := static "about"


authR : Route.Route Sitemap
authR =
    AuthRoute := static "auth/google/callback"


notesR : Route.Route Sitemap
notesR =
    NotesRoute := static "notes"


notesProjectR : Route.Route Sitemap
notesProjectR =
    NotesProjectRoute := static "notes" </> string


sitemap : Route.Router Sitemap
sitemap =
    router [ homeR, aboutR, authR, notesR, notesProjectR ]


removeTrailingSlash : String -> String
removeTrailingSlash s =
    if (String.endsWith "/" s) && (String.length s > 1) then
        String.dropRight 1 s
    else
        s


match : String -> Sitemap
match s =
    s
        |> removeTrailingSlash
        |> Route.match sitemap
        |> Maybe.withDefault NotFoundRoute


toString : Sitemap -> String
toString r =
    case r of
        HomeRoute ->
            reverse homeR []

        AboutRoute ->
            reverse aboutR []

        AuthRoute ->
            reverse authR []

        NotesRoute ->
            reverse notesR []

        NotesProjectRoute projectName ->
            reverse notesProjectR [ projectName ]

        NotFoundRoute ->
            "/404"


parseLocation : Location -> Sitemap
parseLocation location =
    match location.pathname


navigateTo : Sitemap -> Cmd msg
navigateTo =
    toString >> Navigation.newUrl
