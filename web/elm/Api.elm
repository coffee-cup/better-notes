module Api exposing (getCurrentUser, loginFromCode, apiUrl)

import Http
import Json.Decode as Decode exposing (..)
import Messages exposing (Msg(..))
import User exposing (User, decodeUser)


type Method
    = GET
    | POST


getCurrentUser : String -> Cmd Msg
getCurrentUser token =
    let
        request =
            getRequest token "/users/current" decodeUser
    in
        request |> Http.send OnFetchUser


loginFromCode : String -> Cmd Msg
loginFromCode code =
    Http.get (apiUrl "/auth/google/callback?code=" ++ code) decodeToken
        |> Http.send OnFetchLogin


apiUrl : String -> String
apiUrl path =
    "/api/v1" ++ path


getRequest : String -> String -> Decoder a -> Http.Request a
getRequest token path decoder =
    apiRequest token path GET Http.emptyBody decoder


postRequest : String -> String -> Http.Body -> Decoder a -> Http.Request a
postRequest token path body decoder =
    apiRequest token path POST body decoder


apiRequest : String -> String -> Method -> Http.Body -> Decoder a -> Http.Request a
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
