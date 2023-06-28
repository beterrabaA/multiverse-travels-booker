def optimal_stops(expanded : Bool, stops : Array(LocationMapping))
  popularity = Hash(String, Int32).new
  dimension_popularity = Hash(String, Float64).new
  sorted_stops = Array(LocationMapping).new

  stops.each do |stop|
    popularity[stop.id] = stop.residents.sum { |resident| resident.episode.size }
    dimension_popularity[stop.dimension] = 0.0
  end

  stops.each do |stop|
    dimension_popularity[stop.dimension] += popularity[stop.id]
  end

  dimension_popularity.each do |key, value|
    dimension_popularity[key] = value / stops.count { |stop| stop.dimension == key }
  end

  sorted_dimension = dimension_popularity.keys.sort_by { |dimension| {dimension_popularity[dimension], dimension} }

  sorted_dimension.each do |dimension|
    stops_in_dimension = stops.select { |stop| stop.dimension == dimension }
    sorted_stops.concat(stops_in_dimension.sort_by { |stop| {popularity[stop.id], stop.name} })
  end
  if expanded
    sorted_stops.map { |sorted_stop| {
      id:        sorted_stop.id.to_i32,
      name:      sorted_stop.name,
      type:      sorted_stop.type,
      dimension: sorted_stop.dimension,
    } }
  else
    sorted_stops.map { |x| x.id.to_i32 }
  end
end
