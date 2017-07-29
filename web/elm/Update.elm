port module Update exposing (..)

import Http exposing (decodeUri)
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
import Notes.Messages
import Notes.Update


port pageView : String -> Cmd msg


port saveToken : String -> Cmd msg


port newNotes : String -> Cmd msg


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

        SidebarMsg sidebarMsg ->
            handleSidebarMsg sidebarMsg model

        NotesMsg notesMsg ->
            handleNotesMsg notesMsg model

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
                ( { newModel | selectedProject = findSelectedProject newModel }, newNotes "" )

        OnFetchNotes (Err _) ->
            ( errorModel model "Error fetching notes", Cmd.none )

        OnCreateNote (Ok note) ->
            let
                newProjects =
                    addNoteToProject note.projectId note model.projects

                newModel =
                    { model | projects = newProjects }

                newModel2 =
                    { newModel | selectedProject = findSelectedProject newModel }
            in
                handleNotesMsg
                    Notes.Messages.ClearNoteText
                    newModel2

        OnCreateNote (Err _) ->
            ( errorModel model "Error creating note", Cmd.none )

        OnDeleteNote (Ok ( projectId, noteId )) ->
            handleDeleteNote projectId noteId model

        OnDeleteNote (Err _) ->
            ( errorModel model "Error deleting note", Cmd.none )


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


handleNotesMsg : Notes.Messages.Msg -> Model -> ( Model, Cmd Msg )
handleNotesMsg msg model =
    case msg of
        Notes.Messages.ToggleSidebar ->
            ( { model | sidebarOpen = not model.sidebarOpen }, Cmd.none )

        Notes.Messages.CreateNote noteText ->
            let
                newCmd =
                    case model.selectedProject of
                        Just project ->
                            if noteText /= "" then
                                createProjectNote model.token noteText project
                            else
                                Cmd.none

                        Nothing ->
                            Cmd.none
            in
                ( model, Cmd.batch [ newCmd, (newNotes "") ] )

        Notes.Messages.DeleteNote note ->
            ( model, deleteProjectNote model.token note )

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

        Sidebar.Messages.ToggleSidebar ->
            ( { model | sidebarOpen = not model.sidebarOpen }, Cmd.none )

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


handleDeleteNote : Int -> Int -> Model -> ( Model, Cmd Msg )
handleDeleteNote projectId noteId model =
    let
        newProjects =
            List.map
                (\p ->
                    if projectId == p.id then
                        { p | notes = (List.filter (\n -> n.id /= noteId) p.notes) }
                    else
                        p
                )
                model.projects

        newModel =
            { model | projects = newProjects }
    in
        ( { newModel | selectedProject = findSelectedProject newModel }, Cmd.none )


errorModel : Model -> String -> Model
errorModel model error =
    { model | error = error }
