port module Update exposing (..)

import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Messages exposing (Msg(..))
import Models exposing (Model)
import Routing exposing (parseLocation, navigateTo, Sitemap(..))
import Api exposing (getCurrentUser)
import Chat.Messages
import Chat.Update
import Notes.Messages
import Notes.Update


port pageView : String -> Cmd msg


port saveToken : String -> Cmd msg


changePage : Sitemap -> Cmd msg
changePage page =
    Cmd.batch
        [ navigateTo page
        , pageView (Routing.toString page)
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )

        OnFetchText (Ok newText) ->
            ( { model | text = newText }, Cmd.none )

        OnFetchText (Err _) ->
            ( model, Cmd.none )

        ReceiveChatMessage chatMessage ->
            let
                ( newChatModel, chatCmd, outMsg ) =
                    Chat.Update.update (Chat.Messages.ReceiveMessage chatMessage) model.chatModel

                newModel =
                    { model | chatModel = newChatModel }

                newCmd =
                    Cmd.map ChatMsg chatCmd

                ( newModel_, newCmd_ ) =
                    handleChatOutMsg outMsg ( newModel, newCmd )
            in
                ( newModel_, newCmd_ )

        JoinChannel ->
            let
                channel =
                    Phoenix.Channel.init "room:lobby"

                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.join channel model.phxSocket
            in
                ( { model | phxSocket = phxSocket }
                , Cmd.map PhoenixMsg phxCmd
                )

        ChatMsg chatMsg ->
            let
                ( newChatModel, chatCmd, outMsg ) =
                    Chat.Update.update chatMsg model.chatModel

                newModel =
                    { model | chatModel = newChatModel }

                newCmd =
                    Cmd.map ChatMsg chatCmd

                ( newModel_, newCmd_ ) =
                    handleChatOutMsg outMsg ( newModel, newCmd )
            in
                ( newModel_, newCmd_ )

        NotesMsg notesMsg ->
            let
                ( newNotesModel, notesCmd, outMsg ) =
                    Notes.Update.update notesMsg model.notesModel

                newModel =
                    { model | notesModel = newNotesModel }

                newCmd =
                    Cmd.map NotesMsg notesCmd

                ( newModel_, newCmd_ ) =
                    handleNotesOutMsg outMsg ( newModel, newCmd )
            in
                ( newModel_, newCmd_ )

        PhoenixMsg msg ->
            let
                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.update msg model.phxSocket
            in
                ( { model | phxSocket = phxSocket }
                , Cmd.map PhoenixMsg phxCmd
                )

        ShowHome ->
            ( model, changePage HomeRoute )

        ShowAbout ->
            ( model, changePage AboutRoute )

        OnFetchLogin (Ok token) ->
            ( { model | token = token }
            , Cmd.batch
                [ saveToken token
                , changePage NotesRoute
                , getCurrentUser token
                ]
            )

        OnFetchLogin (Err _) ->
            ( { model | error = "Error logging in" }, changePage HomeRoute )

        OnFetchUser (Ok user) ->
            ( { model | user = Just user }, Cmd.none )

        OnFetchUser (Err _) ->
            ( { model | error = "Error fetching user" }, changePage HomeRoute )


handleChatOutMsg : Maybe Chat.Messages.OutMsg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
handleChatOutMsg maybeOutMsg ( model, cmd ) =
    case maybeOutMsg of
        Nothing ->
            ( model, cmd )

        Just outMsg ->
            case outMsg of
                Chat.Messages.Say message ->
                    let
                        payload =
                            Chat.Update.encodeMessage message

                        push_ =
                            Phoenix.Push.init "new:msg" "room:lobby"
                                |> Phoenix.Push.withPayload payload

                        ( phxSocket, phxCmd ) =
                            Phoenix.Socket.push push_ model.phxSocket
                    in
                        ( { model | phxSocket = phxSocket }
                        , Cmd.batch
                            [ cmd
                            , Cmd.map PhoenixMsg phxCmd
                            ]
                        )


handleNotesOutMsg : Maybe Notes.Messages.OutMsg -> ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
handleNotesOutMsg maybeOutMsg ( model, cmd ) =
    case maybeOutMsg of
        Nothing ->
            ( model, cmd )

        Just outMsg ->
            case outMsg of
                Notes.Messages.ToggleSidebar ->
                    ( { model | sidebarOpen = not model.sidebarOpen }, cmd )
