import Html exposing(..)
import Html.Attributes exposing(href, class, style)

import Http

-- import Json.Decode as Decode
import Json.Decode exposing(..)
import Json.Decode.Pipeline exposing (decode, required)

import Time exposing (Time, second)

import Dict exposing(..)

import Navigation exposing(Location)

import Bootstrap.Navbar as Navbar
import Bootstrap.Grid as Grid


poll_interval_sec: number
poll_interval_sec = 3 -- 20

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
    update_timestamp: Int
}

type alias DummyOrca = {
    endpoint: Endpoint
}

type alias Orca = {
    -- TODO
    endpoints: List Endpoint,
    info: Info,
    state: Dict String StateRecord
}

type alias OrcasPod = Dict String Orca

type alias Model = {
    content: String,
    cnt: Int,
    nav_state: Navbar.State
}

-- Update

type Msg =
    Self
    | Tick Time
    | UrlChange Location
    | NavMsg Navbar.State
    | NewPod (Result Http.Error String)


update msg model =
    case msg of
        Self -> (model, Cmd.none)
        Tick time ->
            let _ = Debug.log "tick" time
            in
            ({model | cnt = model.cnt + 1} , get_pod)

        NavMsg state ->
            ({model | nav_state = state} , Cmd.none)
        UrlChange location ->
            (model, Cmd.none)
        NewPod (Ok pod) ->
            let _ = Debug.log "get pod" pod
            in
            (model, Cmd.none)
        NewPod (Err e) ->
            let _ = Debug.log "err" e
            in
            (model, Cmd.none)

get_pod =
    let url = "api/v1/orcas"
        request = Http.getString url
    in
        Http.send NewPod request

--decode_pod =
--    Decode.at ["a"] Decode.String

-- Subscriptions

subscriptions model =
    Time.every (poll_interval_sec * second) Tick

-- View

view model =
    div
        []
        [
            menu model,
            main_view model
        ]


menu model =
    Navbar.config NavMsg
        |> Navbar.withAnimation
        |> Navbar.container
        |> Navbar.brand [ href "#" ] [ text "Harpoon" ]
        |> Navbar.view model.nav_state


main_view model =
    Grid.container [] <|
        [
            Grid.row []
            [
                Grid.col [] [
                    text (toString model.cnt)
                ]
            ]
        ]

-- Main

main =
    let (nav_state, cmd) = Navbar.initialState NavMsg in
    let model = {
        content = "init",
        cnt = 0,
        nav_state = nav_state }
    in
    Html.program
    {
        init = (model, cmd),
        view = view,
        update = update,
        subscriptions = subscriptions
    }
