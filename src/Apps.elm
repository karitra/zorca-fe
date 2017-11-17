module Apps exposing(Application, Apps, apps_decode, application_decode)

import Json.Decode exposing(..)
import Json.Decode.Pipeline exposing(decode, required)

import Dict exposing(..)

type alias Application = {
    hosts: List (String, Int),
    profiles: List String,
    total_count: Int
}

type alias Apps = Dict String Application


arrays_as_tuple2 : Decoder a -> Decoder b -> Decoder (a, b)
arrays_as_tuple2 a b =
    index 0 a
        |> andThen (\aVal -> index 1 b
        |> andThen (\bVal -> succeed (aVal, bVal)))

-- hosts_decode =
--     field "hosts" <| list <| arrays_as_tuple2 string int

application_decode =
    decode Application
        |> required "hosts" (list (arrays_as_tuple2 string int))
        |> required "profiles" (list string)
        |> required "total_workers" int

apps_decode =
    dict application_decode
