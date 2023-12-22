get "/" do |env|
  env.redirect "/travels_stops", 200
end

error 400 do
  {"message": "array of travels_stops is empty"}.to_json
end

error 401 do
  {"message": "unauthorized"}.to_json
end

error 403 do
  {"message": "access forbidden!"}.to_json
end

error 404 do
  {"message": "resousce not found!"}.to_json
end

error 500 do
  {"message": "oops! something went wrong."}.to_json
end
