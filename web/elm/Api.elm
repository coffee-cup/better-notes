module Api
    exposing
        ( getCurrentUser
        , loginFromCode
        , apiUrl
        , getProjects
        , createProject
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
    let
        request =
            getRequest token Projects decodeProjects
    in
        request |> Http.send OnFetchProjects


createProject : Token -> String -> Cmd Msg
createProject token name =
    let
        body =
            encodeNewProject name |> Http.jsonBody

        request =
            postRequest token Projects body decodeProject
    in
        request |> Http.send OnCreateProject


apiUrl : String -> String
apiUrl path =
    "/api/v1" ++ path


getRequest : Token -> Route -> Decoder a -> Http.Request a
getRequest token route decoder =
    apiRequest token route GET Http.emptyBody decoder


postRequest : Token -> Route -> Http.Body -> Decoder a -> Http.Request a
postRequest token route body decoder =
    apiRequest token route POST body decoder


apiRequest : Token -> Route -> Method -> Http.Body -> Decoder a -> Http.Request a
apiRequest token route method body decoder =
    let
        path =
            routeToString route

        headers =
            [ Http.header "Authorization" ("Bearer " ++ token)
            ]
    in
        Http.request
            { method = (methodToString method)
            , headers = headers
            , url = apiUrl path
            , body = body
            , expect = Http.expectJson decoder
            , timeout = Nothing
            , withCredentials = False
            }


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
