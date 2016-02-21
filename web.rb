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


def isWallOrSnake?(coord, responseJson)
    snakeArray = responseJson["snakes"]
    width = responseJson["width"]
    height = responseJson["height"]
    coords = []
    snakeArray.each do |snake|
      snakeCoords =  snake["coords"]
        snakeCoords.each do |snakeCoords|
            coords.push snakeCoords
        end
    end
    isSnake = coords.include? coord 
    return isSnake || coord[0] == 1 || coord[0] == width || coord[1] == 1 || coord[1] == height
end

def onlyKeepSafeCoordinates(adjacentCoordinates, responseJson)
    safeAdjacent = []
    adjacentCoordinates.each do |coord|
      puts coord.to_s
      if isWallOrSnake?(coord, responseJson)
        puts "wall or snake not keeping"
      else 
        safeAdjacent.push(coord)
      end
    end
    puts safeAdjacent.to_s
end

# Orders food by # of moves from to a coordinate
def getOrderedFood(food, coord)
    orderedFood = food.sort_by { |apple| (apple[0] - coord[0]).abs + (apple[1] - coord[1]).abs }
    puts "ORDERED FOOD: " +  orderedFood.to_s
end

def getBestMoveInTermsOfFood(orderedFood, moveOptions)
    targetFood = orderedFood[0]
    orderedMoveOptions = moveOptions.sort_by { |move|  (move[0] - targetFood[0]).abs + (move[1] - targetFood[1]).abs }
    
    bestFoodMove = orderedMoveOptions.first
    puts "BEST FOOD MOVE: " + bestFoodMove.to_s

    return bestFoodMove
end

get '/' do
    responseObject = {
        "color"=> "#bada55",
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
    puts requestJson["snakes"] 

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
    puts requestJson

    # Identify us
    boomslang = requestJson["snakes"].detect { |snake| snake["id"] == "76bbcf39-5b5e-4888-a3a7-808c88fb8126" }
    boomslangHead = boomslang["coords"][0]
    adjacentCoordinates  = getAdjacentCoordinates(boomslang["coords"][0])
    puts "this are adjacent coord: " + adjacentCoordinates.to_s
    
    orderedFood = getOrderedFood(requestJson["food"], boomslangHead)
    moveOptions = onlyKeepSafeCoordinates(adjacentCoordinates, responseJson)

    bestMoveCoords = getBestMoveInTermsOfFood(orderedFood, moveOptions)

    puts "BEST MOVE IS!!"
    puts bestMoveCoords.to_s
    
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
