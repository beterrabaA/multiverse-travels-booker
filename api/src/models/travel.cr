class Travel < Model

  mapping(
    id: Primary32,
  )

  has_many :destinations, Destination, foreign: :travel_id, dependent: :destroy

end
