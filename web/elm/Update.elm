port module Update exposing (..)

import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Messages exposing (Msg(..))
import Models exposing (Model)
import Routing exposing (parseLocation, navigateTo, Sitemap(..))
import Api exposing (..)
import Types.Project exposing (Project, lookupProject)
import Sidebar.Messages
import Sidebar.Update
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
                handleRoute { model | route = newRoute }

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

        SidebarMsg sidebarMsg ->
            handleSidebarMsg sidebarMsg model

        NotesMsg notesMsg ->
            handleNotesMsg notesMsg model

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
            ( { model | user = Just user }, getProjects model.token )

        OnFetchUser (Err _) ->
            ( { model | error = "Error fetching user" }, changePage HomeRoute )

        OnFetchProjects (Ok projects) ->
            handleRoute { model | projects = projects }

        OnFetchProjects (Err _) ->
            ( { model | error = "Error fetching projects" }, Cmd.none )

        OnCreateProject (Ok project) ->
            let
                ( newModel, newCmd ) =
                    handleSidebarMsg (Sidebar.Messages.ClearProjectName) { model | projects = project :: model.projects }
            in
                ( newModel
                , Cmd.batch
                    [ newCmd
                    , changePage (NotesProjectRoute project.name)
                    ]
                )

        OnCreateProject (Err _) ->
            ( { model | error = "Error creating project" }, Cmd.none )

        OnDeleteProject (Ok projectId) ->
            handleDeleteProject projectId model

        OnDeleteProject (Err _) ->
            ( { model | error = "Error deleting project" }, Cmd.none )


handleRoute : Model -> ( Model, Cmd Msg )
handleRoute model =
    case model.route of
        NotesProjectRoute projectName ->
            ( { model | selectedProject = lookupProject projectName model.projects }, Cmd.none )

        _ ->
            ( model, Cmd.none )


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


handleNotesMsg : Notes.Messages.Msg -> Model -> ( Model, Cmd Msg )
handleNotesMsg msg model =
    case msg of
        Notes.Messages.ToggleSidebar ->
            ( { model | sidebarOpen = not model.sidebarOpen }, Cmd.none )

        _ ->
            let
                ( newNotesModel, newNotesMsg ) =
                    Notes.Update.update msg model.notesModel
            in
                ( { model | notesModel = newNotesModel }
                , Cmd.map NotesMsg newNotesMsg
                )


handleSidebarMsg : Sidebar.Messages.Msg -> Model -> ( Model, Cmd Msg )
handleSidebarMsg msg model =
    case msg of
        Sidebar.Messages.CreateProject projectName ->
            ( model, createProject model.token projectName )

        Sidebar.Messages.DeleteProject project ->
            ( model, deleteProject model.token project )

        Sidebar.Messages.SelectProject project ->
            ( model, changePage (NotesProjectRoute project.name) )

        _ ->
            let
                ( newSidebarModel, newSidebarMsg ) =
                    Sidebar.Update.update msg model.sidebarModel
            in
                ( { model | sidebarModel = newSidebarModel }
                , Cmd.map SidebarMsg newSidebarMsg
                )


handleDeleteProject : Int -> Model -> ( Model, Cmd Msg )
handleDeleteProject projectId model =
    let
        newProjects =
            List.filter (\p -> p.id /= projectId) model.projects

        newCmd =
            case model.selectedProject of
                Just project ->
                    if project.id == projectId then
                        case List.head newProjects of
                            Just headProject ->
                                changePage (NotesProjectRoute headProject.name)

                            Nothing ->
                                changePage NotesRoute
                    else
                        Cmd.none

                Nothing ->
                    Cmd.none
    in
        ( { model | projects = newProjects }, newCmd )
