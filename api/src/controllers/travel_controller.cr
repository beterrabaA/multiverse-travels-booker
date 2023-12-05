require "../services/travel_service.cr"

BASE_ENDPOINT = "/travel_plans"

class TravelController
  trav_service = TravelService.new
  dest_service = DestinationService.new

  get BASE_ENDPOINT do |env|
    env.response.content_type = "application/json"
    expand = env.params.query["expand"]?
    optimize = env.params.query["optimize"]?

    trav_service.query_all optimize == "true", expand == "true"
  end

  get BASE_ENDPOINT + "/:id" do |env|
    env.response.content_type = "application/json"
    optimize = env.params.query["optimize"]?
    expand = env.params.query["expand"]?
    id = env.params.url["id"]

    unless Travel.find(id).nil?
      response = trav_service.query_byId id.to_i64, expand == "true", optimize == "true"
      response.to_json
    else
      env.response.status = HTTP::Status::NOT_FOUND
    end
  end

  post BASE_ENDPOINT do |env|
    env.response.content_type = "application/json"
    env.response.status_code = 201
    travels = env.params.json["travel_stops"].as(Array)
    if travels.empty?
      env.response.status_code = 400

      {"message": "array of travels_stops is empty"}.to_json
    else
      plan_created = Travel.create

      dest_service.insert_destinations travels.to_s, plan_created.id.as(Int32)
    end
  end

  put BASE_ENDPOINT + "/:id" do |env|
    env.response.content_type = "application/json"
    travels = env.params.json["travel_stops"].as(Array)
    id = env.params.url["id"]

    reponse = dest_service.update_destinations travels.to_s, id.to_i64
    reponse.to_json
  end

  delete BASE_ENDPOINT + "/:id" do |env|
    env.response.status_code = 204
    id = env.params.url["id"]

    unless Travel.find(id).nil?
      Travel.find!(id).destroy
    else
      env.response.status = HTTP::Status::NOT_FOUND
    end
  end

  patch BASE_ENDPOINT + "/:id/append" do |env|
    env.response.content_type = "application/json"
    travels = env.params.json["travel_stops"].as(Array)
    id = env.params.url["id"]
    if travels.empty?
      env.response.status_code = 400

      {"message": "array of travels_stops is empty"}.to_json
    else
      reponse = dest_service.append_destinations travels.to_s, id.to_i32
      reponse.to_json
    end
  end
end
