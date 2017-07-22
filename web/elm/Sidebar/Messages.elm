module Sidebar.Messages exposing (..)

import Types.Project exposing (Project)


type Msg
    = SetNewProjectName String
    | ClearProjectName
    | CreateProject String
    | DeleteProject Project
    | SelectProject Project
    | ToggleSidebar
