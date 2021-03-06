module Mayoy.App.Subscriptions exposing (subscriptions)

import Mayoy.App.Message exposing (Message(ConnectMessage, WorkspaceMessage))
import Mayoy.App.Model exposing (Model(WorkspaceModel))
import Mayoy.Connect.Message as Connect
import Mayoy.Workspace.Message as Workspace
import Mayoy.App.Port exposing (..)
import Time exposing (Time, second)
import Mayoy.Model exposing (QueryResult(Running))


subscriptions : Model -> Sub Message
subscriptions model =
    Sub.batch
        [ connectionEstablished (ConnectMessage << Connect.ConnectionEstablished)
        , connectionFailed (ConnectMessage << Connect.ConnectionFailed)
        , connectionClosed (WorkspaceMessage << Workspace.ConnectionClosed)
        , closeConnectionFailed (WorkspaceMessage << Workspace.CloseConnectionFailed)
        , receiveConnectionHistoryFromLocalStorage (ConnectMessage << Connect.ReceiveConnectionHistory)
        , receiveEditorLastValueFromLocalStorage (WorkspaceMessage << Workspace.ReceiveEditorLastValue)
        , pressRunInCodemirror (WorkspaceMessage << \_ -> Workspace.Run)
        , receiveTextFromCodemirror (WorkspaceMessage << Workspace.ReceiveValueFromEditor)
        , selectText (WorkspaceMessage << Workspace.ReceiveValueInSelectionFromEditor)
        , receiveTextInCurrentLineFromCodemirror (WorkspaceMessage << Workspace.ReceiveValueInCurrentLineFromEditor)
        , queryFailed (WorkspaceMessage << Workspace.QueryFailed)
        , receiveColumns (WorkspaceMessage << Workspace.ReceiveColumns)
        , receiveRow (WorkspaceMessage << Workspace.ReceiveRow)
        , receiveResult (WorkspaceMessage << Workspace.ReceiveResult)
        , receiveEnd (WorkspaceMessage << Workspace.ReceiveEnd)
        , (case model of
            WorkspaceModel model ->
                case model.result of
                    Just (Running passed) ->
                        Time.every second (\time -> WorkspaceMessage <| Workspace.CountQueryExecutionTime (passed + second))

                    _ ->
                        Sub.none

            _ ->
                Sub.none
          )
        ]
