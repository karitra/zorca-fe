import Html exposing(..)
import Html.Attributes exposing(href, class, style)

import Json.Decode exposing (..)
import Json.Decode.Pipeline exposing (decode, required)

import Time exposing (Time, second)

import Core exposing(Dict)


poll_interval_sec: number
poll_interval_sec = 20

-- Model

type alias StateRecord = {
    profile: String,
    workers: Int,
    state: String,
    state_version: Int,
    time_stamp: Int
}

type alias Endpoint = (String, Int)
type alias Info = {
    uptime: Int,
    uuid: String,
    version: String,
    update_timestamp: Int,
}

type alias Orca = {
    -- TODO
    ph: String,
    endpoints: List Endpoint,
    info: Info,
    state: Dict String StateRecord
}

type alias OrcasPod = Dict String Orca

type alias Model = {
    content: String,
    cnt: Int
}

model = {
    content = "init",
    cnt = 0}

-- Update

type Msg =
    Self |
    Tick Time


update msg model =
    case msg of
        Self -> (model, Cmd.none)
        Tick time ->
            Debug.log "Boo"
            ( {model | cnt = model.cnt + 1} , Cmd.none)


-- Subscriptions

subscriptions model =
    Time.every (poll_interval_sec * second) Tick

-- View

view model =
    div
        [ style [("padding", "2rem")] ]
        [
            text model.content,
            text (toString model.cnt)
        ]


-- Main

main =
    Html.program
    {
        init = (model, Cmd.none),
        view = view,
        update = update,
        subscriptions = subscriptions
    }
