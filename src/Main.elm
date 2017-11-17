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
-- import Bootstrap.Color as Color

import Orca exposing(..)
import Apps exposing(..)


poll_interval_sec: number
poll_interval_sec = 10

-- Model

type alias Model = {
    content: String,
    cnt: Int,
    pod: Maybe OrcasPod,
    apps: Maybe Apps,
    nav_state: Navbar.State
}

-- Update

type Msg =
    Self
    | Tick Time
    | UrlChange Location
    | NavMsg Navbar.State
    | NewPod (Result Http.Error OrcasPod)
    | NewApps (Result Http.Error Apps)

update msg model =
    case msg of
        Self -> (model, Cmd.none)
        Tick time ->
            -- TODO: request cluster and apps
            let _ = Debug.log "tick" time
            in
            ({model | cnt = model.cnt + 1} , Cmd.batch [get_pod, get_apps])
        NavMsg state ->
            let _ = Debug.log "nav" state
            in
            ({model | nav_state = state} , Cmd.none)
        UrlChange location ->
            (model, Cmd.none)
        NewPod (Ok pod) ->
            let _ = Debug.log "get pod" pod
            in
            ({model | pod = Just pod}, Cmd.none)
        NewPod (Err e) ->
            let _ = Debug.log "err" e
            in
            (model, Cmd.none)
        NewApps (Ok apps) ->
            let _ = Debug.log "get apps" apps
            in
            ({model | apps = Just apps}, Cmd.none)
        NewApps (Err e) ->
            let _ = Debug.log "err" e
            in
            (model, Cmd.none)


get_pod =
    let url = "api/v1/orcas"
        request = Http.get url orcas_pod_decode
    in
        Http.send NewPod request

get_apps =
    let url = "api/v1/apps"
        request = Http.get url apps_decode
    in
        Http.send NewApps request


subscriptions model =
    Sub.batch [
        Time.every (poll_interval_sec * second) Tick,
        Navbar.subscriptions model.nav_state NavMsg
    ]


-- View

view model =
    -- let row_opt = Grid.attrs []
    -- in
    Grid.containerFluid [style [("width", "100%")]]
        [
            Grid.row [] [Grid.col [] [   navbar model] ],
            Grid.row [] [Grid.col [] [main_view model] ]
        ]

navbar model =
    Navbar.config NavMsg
        |> Navbar.attrs [
            class "bg-dark",
            class "navbar-dark",
            class "navbar-collapse-sm" ]
            -- class "fixed-top"]
        |> Navbar.brand [ href "#" ] [ text "z-Orca" ]
        |> Navbar.items
            [ Navbar.itemLink [ href "#cluster" ] [ text "Cluster" ]
            , Navbar.itemLink [ href "#orcas" ] [ text "Orcas" ]
            , Navbar.itemLink [ href "#apps" ] [ text "Applications" ]
            , Navbar.itemLink [ href "#self" ] [ text "Self info" ]
            ]
        |> Navbar.view model.nav_state


main_view model =
    Grid.container []
    [
        text (toString model.cnt)
    ]

-- Main

main =
    let (nav_state, cmd) = Navbar.initialState NavMsg in
    let model = {
        content = "init",
        cnt = 0,
        pod = Nothing,
        apps = Nothing,
        nav_state = nav_state }
    in
    Html.program
    {
        init = (model, cmd),
        view = view,
        update = update,
        subscriptions = subscriptions
    }
