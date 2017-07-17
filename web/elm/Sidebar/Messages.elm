module Sidebar.Messages exposing (..)

import Types.Project exposing (Project)


type Msg
    = SetNewProjectName String
    | CreateProject String
    | ReceiveProjects (List Project)
