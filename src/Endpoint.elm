module Endpoint exposing(Endpoint, endpoints_decode, arrays_as_tuple2)

import Json.Decode exposing(..)

type alias Endpoint = (String, Int)

arrays_as_tuple2 : Decoder a -> Decoder b -> Decoder (a, b)
arrays_as_tuple2 a b =
    index 0 a
        |> andThen (\aVal -> index 1 b
        |> andThen (\bVal -> succeed (aVal, bVal)))

endpoints_decode =
    field "endpoints" <| list <| arrays_as_tuple2 string int
