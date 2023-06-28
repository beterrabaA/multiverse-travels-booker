require "json"
require "../config/config"
require "dotenv"

module RickAndMortyTravels
  VERSION = "0.1.0"

  Dotenv.load
  Kemal.run
end
