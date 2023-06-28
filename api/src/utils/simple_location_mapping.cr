class GraphQLMappingSimple
  JSON.mapping(
    data: AllLocationsSimple
  )
end

class AllLocationsSimple
  JSON.mapping(
    locationsByIds: Array(SimpleLocation)
  )
end

class SimpleLocation
  JSON.mapping(
    id: String,
    name: String,
    type: String,
    dimension: String,
  )
end
