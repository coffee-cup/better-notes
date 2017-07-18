module Api
    exposing
        ( getCurrentUser
        , loginFromCode
        , apiUrl
        , getProjects
        , createProject
        , deleteProject
        )

import Http
import Json.Decode as Decode exposing (..)
import Messages exposing (Msg(..))
import Types.User
    exposing
        ( User
        , decodeUser
        )
import Types.Project
    exposing
        ( Project
        , decodeProject
        , decodeProjects
        , encodeNewProject
        )


type Method
    = GET
    | POST
    | PUT
    | DELETE


type Route
    = Users
    | Projects
    | DeleteProject Int


type alias Token =
    String


getCurrentUser : Token -> Cmd Msg
getCurrentUser token =
    let
        request =
            getRequest token Users decodeUser
    in
        request |> Http.send OnFetchUser


loginFromCode : String -> Cmd Msg
loginFromCode code =
    Http.get (apiUrl "/auth/google/callback?code=" ++ code) decodeToken
        |> Http.send OnFetchLogin


getProjects : Token -> Cmd Msg
getProjects token =
    (getRequest token Projects decodeProjects)
        |> Http.send OnFetchProjects


createProject : Token -> String -> Cmd Msg
createProject token name =
    let
        body =
            encodeNewProject name |> Http.jsonBody

        request =
            postRequest token Projects body decodeProject
    in
        request |> Http.send OnCreateProject


deleteProject : Token -> Project -> Cmd Msg
deleteProject token project =
    (deleteRequest token (DeleteProject project.id) project.id)
        |> Http.send OnDeleteProject


apiUrl : String -> String
apiUrl path =
    "/api/v1" ++ path


getRequest : Token -> Route -> Decoder a -> Http.Request a
getRequest token route decoder =
    Http.request
        { method = (methodToString GET)
        , headers = apiHeader token
        , url = apiUrl (routeToString route)
        , body = Http.emptyBody
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = False
        }


postRequest : Token -> Route -> Http.Body -> Decoder a -> Http.Request a
postRequest token route body decoder =
    Http.request
        { method = (methodToString POST)
        , headers = apiHeader token
        , url = apiUrl (routeToString route)
        , body = body
        , expect = Http.expectJson decoder
        , timeout = Nothing
        , withCredentials = False
        }


deleteRequest : Token -> Route -> a -> Http.Request a
deleteRequest token route a =
    Http.request
        { method = (methodToString DELETE)
        , headers = apiHeader token
        , url = apiUrl (routeToString route)
        , body = Http.emptyBody
        , expect = alwaysExpect a
        , timeout = Nothing
        , withCredentials = False
        }


alwaysExpect : a -> Http.Expect a
alwaysExpect =
    Http.expectStringResponse << always << Ok


apiHeader : Token -> List Http.Header
apiHeader token =
    [ Http.header "Authorization" ("Bearer " ++ token) ]


decodeToken : Decode.Decoder String
decodeToken =
    field "access_token" Decode.string


methodToString : Method -> String
methodToString method =
    case method of
        GET ->
            "GET"

        POST ->
            "POST"

        PUT ->
            "PUT"

        DELETE ->
            "DELETE"


routeToString : Route -> String
routeToString route =
    case route of
        Users ->
            "/users"

        Projects ->
            "/projects"

        DeleteProject id ->
            "/projects" ++ "/" ++ (toString id)
