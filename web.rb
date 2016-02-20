require 'sinatra'
require 'json'

id = "76bbcf39-5b5e-4888-a3a7-808c88fb8126"


def getAdjacentCoordinates(coord)
    north = [coord[0], coord[1] - 1]
    south = [coord[0], coord[1] + 1]
    east = [coord[0] + 1, coord[1]]
    west = [coord[0] - 1, coord[1]]

    return [north, south, east, west]
end

# def isWAll?(coordinate, )

# end

# def isSnake?(coordinate,  )
def isWallOrSnake(requestJSON)
    snakeArray = requestJSON["snakes"]
    snakeCoords = snakeArray.map{|x| x[:"coord"]}
    puts snakeArray
    # snakes = 
end

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
    
    # puts boomslang

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

    # Identify us
    boomslang = requestJson["snakes"].detect { |snake| snake[:id] == "76bbcf39-5b5e-4888-a3a7-808c88fb8126" }

    getAdjacentCoordinates(boomslang[:coords][0])
    # isWallOrSnake(requestJSON)
    # Our next move is not towards a wall
    # Identify possible moves

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
