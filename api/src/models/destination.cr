class Destination < Model
  mapping(
    id: Primary32,
    location_id: Int32,
    travel_id: Int32,
  )

  belongs_to :travel, Travel
end
