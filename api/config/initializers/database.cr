require "jennifer"
require "jennifer/adapter/postgres"
require "dotenv"

Dotenv.load

APP_ENV = ENV["APP_ENV"]? || "development"

Jennifer::Config.configure do |conf|
  conf.host = ENV["POSTGRES_HOST"]? || "localhost"
  conf.port = ENV["POSTGRES_PORT"].to_i || 5432
  conf.user = ENV["POSTGRES_USER"]? || "postgres"
  conf.password = ENV["POSTGRES_PASSWORD"]? || "postgres"
  conf.db = ENV["POSTGRES_DB"]? || "postgres"
  conf.adapter = "postgres"
  conf.migration_files_path = "./db/migrations"
  conf.logger = Log.for("db", :debug)
end
