class Travel < Model

  mapping(
    id: Primary64,
  )

  has_many :destinations, Destination, foreign: :travel_id, dependent: :destroy

end
