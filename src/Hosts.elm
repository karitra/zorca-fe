
type alias Endpoint = (String, Int)

type alias Host = {
    hostname: String,
    endpoints: List Endpoint
}
