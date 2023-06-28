class GraphQLMapping
  JSON.mapping(
    data: AllLocations
  )
end

class AllLocations
  JSON.mapping(
    locationsByIds: Array(LocationMapping)
  )
end

class LocationMapping
  JSON.mapping(
    id: String,
    name: String,
    type: String,
    dimension: String,
    residents: Array(Episode),
  )
end

class Episode
  JSON.mapping(
    episode: Array({name: String}),
  )
end