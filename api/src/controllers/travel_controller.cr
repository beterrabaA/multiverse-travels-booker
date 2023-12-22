require "../services/travel_service.cr"

BASE_ENDPOINT = "/travel_plans"

class TravelController
  trav_service = TravelService.new
  dest_service = DestinationService.new

  before_all BASE_ENDPOINT do |env|
    env.response.content_type = "application/json"
  end

  before_get BASE_ENDPOINT do |env|
    expand = env.params.query["expand"]?
    optimize = env.params.query["optimize"]?
  end

  get BASE_ENDPOINT do |env|
    trav_service.query_all optimize == "true", expand == "true"
  end

  get BASE_ENDPOINT + "/:id" do |env|
    id = env.params.url["id"]

    unless Travel.find(id).nil?
      response = trav_service.query_byId id.to_i64, expand == "true", optimize == "true"
      response.to_json
    else
      env.response.status = HTTP::Status::NOT_FOUND
    end
  end

  post BASE_ENDPOINT do |env|
    env.response.status_code = HTTP::Status::CREATED
    travels = env.params.json["travel_stops"].as(Array)
    if travels.empty?
      env.response.status_code = HTTP::Status::BAD_REQUEST
    else
      plan_created = Travel.create

      dest_service.insert_destinations travels.to_s, plan_created.id.as(Int32)
    end
  end

  put BASE_ENDPOINT + "/:id" do |env|
    travels = env.params.json["travel_stops"].as(Array)
    id = env.params.url["id"]

    reponse = dest_service.update_destinations travels.to_s, id.to_i64
    reponse.to_json
  end

  delete BASE_ENDPOINT + "/:id" do |env|
    env.response.status_code = HTTP::Status::NO_CONTENT
    id = env.params.url["id"]

    unless Travel.find(id).nil?
      Travel.find!(id).destroy
    else
      env.response.status = HTTP::Status::NOT_FOUND
    end
  end

  patch BASE_ENDPOINT + "/:id/append" do |env|
    travels = env.params.json["travel_stops"].as(Array)
    id = env.params.url["id"]
    if travels.empty?
      env.response.status_code = HTTP::Status::BAD_REQUEST
    else
      reponse = dest_service.append_destinations travels.to_s, id.to_i32
      reponse.to_json
    end
  end
end
