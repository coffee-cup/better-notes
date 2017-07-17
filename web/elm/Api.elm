module Api exposing (getCurrentUser, loginFromCode, apiUrl, getProjects)

import Http
import Json.Decode as Decode exposing (..)
import Messages exposing (Msg(..))
import Types.User exposing (User, decodeUser)
import Types.Project exposing (Project, decodeProjects)


type Method
    = GET
    | POST


type alias Token =
    String


getCurrentUser : Token -> Cmd Msg
getCurrentUser token =
    let
        request =
            getRequest token "/users" decodeUser
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
            getRequest token "/projects" decodeProjects
    in
        request |> Http.send OnFetchProjects


apiUrl : String -> String
apiUrl path =
    "/api/v1" ++ path


getRequest : Token -> String -> Decoder a -> Http.Request a
getRequest token path decoder =
    apiRequest token path GET Http.emptyBody decoder


postRequest : Token -> String -> Http.Body -> Decoder a -> Http.Request a
postRequest token path body decoder =
    apiRequest token path POST body decoder


apiRequest : Token -> String -> Method -> Http.Body -> Decoder a -> Http.Request a
apiRequest token path method body decoder =
    let
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


methodToString : Method -> String
methodToString method =
    case method of
        GET ->
            "GET"

        POST ->
            "POST"


decodeToken : Decode.Decoder String
decodeToken =
    field "access_token" Decode.string
