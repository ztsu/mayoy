module Mayoy.Connect.Model exposing (Model, init, formToConnectionParameters)

import String
import Mayoy.Model exposing (Connection(NoConnection), ConnectionParameters, defaultPort)


type alias Model =
    { errors : List String
    , connection : Connection
    , form : Form
    }


type alias Form =
    { host : String
    , portNumber : String
    , user : String
    , password : String
    , database : String
    }


emptyForm =
    Form "localhost" (toString defaultPort) "root" "" ""


formToConnectionParameters { host, portNumber, user, password, database } =
    let
        portNumberInt =
            case String.toInt portNumber of
                Ok number ->
                    number

                Err _ ->
                    defaultPort
    in
        ConnectionParameters ( host, portNumberInt ) user password Nothing


init =
    ( Model [] NoConnection emptyForm, Cmd.none )