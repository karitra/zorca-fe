
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
