module Orca exposing(Orca,OrcasPod, orca_decode, orcas_pod_decode)

import Json.Decode exposing(..)
import Json.Decode.Pipeline exposing(decode, required)
import Dict exposing(..)

import Apps exposing(..)
import Endpoint exposing(..)

type alias StateRecord = {
    profile: String,
    workers: Int,
    state: String,
    state_version: Int,
    time_stamp: Int
}

type alias Info = {
    uptime: Int,
    uuid: String,
    version: String
}

type alias DummyOrca = {
    endpoint: Endpoint
}

type alias Orca = {
    endpoints: List Endpoint,
    info: Info,
    state: Dict String StateRecord
}

type alias OrcaRecord = {
    orca: Orca,
    update_timestamp: Int
}

type alias OrcasPod = Dict String OrcaRecord


state_decode =
    decode StateRecord
        |> required "profile" string
        |> required "workers" int
        |> required "state" string
        |> required "state_version" int
        |> required "time_stamp" int

states_list_decode =
    decodeString <| list state_decode

info_decode =
    decode Info
        |> required "uptime" int
        |> required "uuid" string
        |> required "version" string

orca_decode =
    decode Orca
        |> required "endpoints" (list <| arrays_as_tuple2 string int)
        |> required "info" info_decode
        |> required "state" (dict state_decode)

orca_record_decode =
    decode OrcaRecord
        |> required "orca" orca_decode
        |> required "update_timestamp" int

orcas_pod_decode =
    dict orca_record_decode
