port module Update exposing (..)

import Http exposing (decodeUri)
import Phoenix.Socket
import Phoenix.Channel
import Phoenix.Push
import Messages exposing (Msg(..))
import Models exposing (Model)
import Routing exposing (parseLocation, navigateTo, Sitemap(..))
import Api exposing (..)
import Types.Project
    exposing
        ( Project
        , lookupProject
        , addNotesToProject
        , addNoteToProject
        )
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
            ( errorModel model "Error logging in", changePage HomeRoute )

        OnFetchUser (Ok user) ->
            ( { model | user = Just user }, getProjects model.token )

        OnFetchUser (Err _) ->
            ( errorModel model "Error fetching user", changePage HomeRoute )

        OnFetchProjects (Ok projects) ->
            handleRoute { model | projects = projects }

        OnFetchProjects (Err _) ->
            ( errorModel model "Error fetching projects", Cmd.none )

        OnCreateProject (Ok project) ->
            let
                ( newModel, newCmd ) =
                    handleSidebarMsg
                        (Sidebar.Messages.ClearProjectName)
                        { model | projects = List.append model.projects [ project ] }
            in
                ( newModel
                , Cmd.batch
                    [ newCmd
                    , changePage (NotesProjectRoute project.name)
                    ]
                )

        OnCreateProject (Err _) ->
            ( errorModel model "Error creating project", Cmd.none )

        OnDeleteProject (Ok projectId) ->
            handleDeleteProject projectId model

        OnDeleteProject (Err _) ->
            ( errorModel model "Error deleting project", Cmd.none )

        OnFetchNotes (Ok notes) ->
            let
                newProjects =
                    case List.head notes of
                        Just note ->
                            addNotesToProject note.projectId notes model.projects

                        Nothing ->
                            model.projects

                newModel =
                    { model | projects = newProjects }
            in
                ( { newModel | selectedProject = findSelectedProject newModel }, Cmd.none )

        OnFetchNotes (Err _) ->
            ( errorModel model "Error fetching notes", Cmd.none )

        OnCreateNote (Ok note) ->
            let
                newProjects =
                    addNoteToProject note.projectId note model.projects

                newModel =
                    { model | projects = newProjects }
            in
                ( { newModel | selectedProject = findSelectedProject newModel }, Cmd.none )

        OnCreateNote (Err _) ->
            ( errorModel model "Error creating note", Cmd.none )


handleRoute : Model -> ( Model, Cmd Msg )
handleRoute model =
    case model.route of
        NotesProjectRoute projectNameEncoded ->
            let
                selectedProject =
                    findSelectedProject model

                maybeGetNotesCmd =
                    case selectedProject of
                        Just project ->
                            getProjectNotes model.token project

                        Nothing ->
                            Cmd.none
            in
                ( { model
                    | selectedProject = selectedProject
                  }
                , maybeGetNotesCmd
                )

        NotesRoute ->
            ( { model | selectedProject = Nothing }, Cmd.none )

        _ ->
            ( model, Cmd.none )


findSelectedProject : Model -> Maybe Project
findSelectedProject model =
    case model.route of
        NotesProjectRoute projectNameEncoded ->
            lookupProject
                ((decodeUri projectNameEncoded)
                    |> Maybe.withDefault projectNameEncoded
                )
                model.projects

        _ ->
            Nothing


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


errorModel : Model -> String -> Model
errorModel model error =
    { model | error = error }
