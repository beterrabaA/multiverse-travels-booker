require "./travel_service.cr"

class DestinationService
  def update(id : Int64, location_id : Int32, travel_id : Int64)
    Destination.where { _id == id }.update(
      location_id: location_id,
      travel_id: travel_id,
    )
  end

  def update_destinations(ids : String, travel_id : Int64)
    travel_service = TravelService.new
    new_loc_ids = Array(Int32).from_json(ids)
    ponto = Destination.all.where { _travel_id == travel_id }
    destinations = Array(DestinationMapping).from_json("#{ponto.to_json}")

    destinations.map_with_index { |z, i| update z.id, new_loc_ids[i], travel_id }

    travel_service.query_byId travel_id
  end

  def insert_destinations(ids : String, travel_id : Int32)
    objects = Array(Destination).new
    ids_i = Array(Int32).from_json(ids)
    ids_i.each do |id|
      objects << Destination.new({
        location_id: id,
        travel_id:   travel_id,
      })
    end

    teste = Destination.import(objects)
    {id: travel_id, travel_stops: ids_i}.to_json
  end

  def append_destinations(ids : String, travel_id : Int32)
    travel_service = TravelService.new
    insert_destinations ids, travel_id
    travel_service.query_byId travel_id
  end
end
