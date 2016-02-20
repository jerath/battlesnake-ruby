require 'sinatra'
require 'json'

id= "76bbcf39-5b5e-4888-a3a7-808c88fb8126"

get '/' do
    responseObject = {
        "color"=> "#fff111",
        "head_url"=> "url/to/your/img/file"
    }

    return responseObject.to_json
end

post '/start' do
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}
    # Get ready to start a game with the request data
    puts requestBody
    height = requestJson["height"]
    width = requestJson["width"] 
    totalSnakes= requestJson["snakes"].length
    boomslang = requestJson.find {|x| x['id'] == id }
    puts boomslang
# Dummy response
    responseObject = {
        "taunt" => "battlesnake-ruby",
    }

    return responseObject.to_json
end

post '/move' do
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}

    # Calculate a move with the request data
    puts requestBody
    # Dummy response
    responseObject = {
        "move" => "north", # One of either "north", "east", "south", or "west".
        "taunt" => "going north!",
    }

    return responseObject.to_json
end

post '/end' do
    requestBody = request.body.read
    requestJson = requestBody ? JSON.parse(requestBody) : {}

    # No response required
    responseObject = {}

    return responseObject.to_json
end
