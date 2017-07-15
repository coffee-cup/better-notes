module Auth exposing (..)

import Http
import Navigation
import Dict


type alias Client =
    { authorizeUrl : String
    , redirectUri : String
    , responseType : String
    , scope : String
    , accessType : String
    , provider : String
    , clientId : String
    }


googleClient : String -> Client
googleClient clientId =
    { authorizeUrl = "https://accounts.google.com/o/oauth2/v2/auth"
    , redirectUri = "http://localhost:4000/auth/google/callback"
    , responseType = "code"
    , scope = "profile"
    , accessType = "offline"
    , provider = "google"
    , clientId = clientId
    }


buildAuthUrl : Client -> String
buildAuthUrl client =
    url
        client.authorizeUrl
        [ ( "response_type", client.responseType )
        , ( "redirect_uri", client.redirectUri )
        , ( "client_id", client.clientId )
        , ( "scope", client.scope )
        , ( "access_type", client.accessType )
        ]


parseCodeFromQuery : Navigation.Location -> Maybe String
parseCodeFromQuery loc =
    let
        params =
            parseUrlParams loc.search
    in
        Dict.get "code" params


parseUrlParams : String -> Dict.Dict String String
parseUrlParams s =
    s
        |> String.dropLeft 1
        |> String.split "&"
        |> List.map parseSingleParam
        |> Dict.fromList


parseSingleParam : String -> ( String, String )
parseSingleParam p =
    let
        s =
            String.split "=" p
    in
        case s of
            [ s1, s2 ] ->
                ( s1, s2 )

            _ ->
                ( "", "" )


url : String -> List ( String, String ) -> String
url baseUrl args =
    case args of
        [] ->
            baseUrl

        _ ->
            baseUrl ++ "?" ++ String.join "&" (List.map queryPair args)


queryPair : ( String, String ) -> String
queryPair ( key, value ) =
    Http.encodeUri key ++ "=" ++ Http.encodeUri value
