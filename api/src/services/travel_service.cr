API_URL = "https://rickandmortyapi.com/graphql"

class TravelService
  services = TravelService.new

  def query_all(optimized : Bool = false, expanded : Bool = false)
    plans = Travel.all
    array_plans = Array(TravelMapping).from_json "#{plans.to_json}"
    array_plans.map { |z| query_byId z.id, expanded, optimized }.to_json
  end

  def query_travel(id : Int64)
    destinations = Destination.all.where { _travel_id == id }
    array_destinations = Array(DestinationMapping).from_json("#{destinations.to_json}")

    array_destinations.map { |z| z.location_id }
  end

  def query_byId(id : Int64, expanded : Bool = false, optimized : Bool = false)
    if (optimized)
      {
        id:           id,
        travel_stops: optimal_stops expanded, request_graphql id,
      }
    elsif !optimized && expanded
      {
        id:           id,
        travel_stops: simple_graphql request_graphql id,
      }
    else
      {
        id:           id,
        travel_stops: query_travel id,
      }
    end
  end

  def request_graphql(id : Int64)
    ids_array = query_travel id
    query = "{locationsByIds(ids: #{ids_array}) {id name type dimension residents {episode {name}}}}"
    teste = {"query" => query}
    response = HTTP::Client.post API_URL, headers: HTTP::Headers{"Content-Type" => "application/json"}, body: teste.to_json
    graphql = Array(GraphQLMapping).from_json("[#{response.body}]")
    graphql[0].data.locationsByIds
  end

  def simple_graphql(stops : Array(LocationMapping))
    stops.map { |z| {
      id:        z.id.to_i,
      name:      z.name,
      type:      z.type,
      dimension: z.dimension,
    } }
  end
end
