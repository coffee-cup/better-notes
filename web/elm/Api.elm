module Api exposing (..)


apiUrl : String -> String
apiUrl path =
    "/api/v1" ++ path
