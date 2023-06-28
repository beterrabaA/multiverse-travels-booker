class Destination < Model
  mapping(
    id: Primary64,
    location_id: Int32,
    travel_id: Int64,
  )

  belongs_to :travel, Travel
end
