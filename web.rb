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

# use getHashKeyDirections with (getAdjacentCoordinates(coord), and then coord we want to go to)

def getHashKeyDirections(arrayNSET, coord)
  directions = {}
  directions["north"] = arrayNSET[0]
  directions["south"] = arrayNSET[1]
  directions["east"] = arrayNSET[2]
  directions["west"] = arrayNSET[3]
  return directions.key(coord).to_s
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
    return isSnake || coord[0] < 0 || coord[0] > (width - 1) || coord[1] < 0 || coord[1] > (height - 1)
end

def onlyKeepSafeCoordinates(adjacentCoordinates, responseJson)
    
    puts "HEY IM IN THIE SMESHHETHOD "
    puts responseJson.to_s
    puts "END RESPONSE DATA FROM SAFE COORDS"

    safeAdjacent = []
    adjacentCoordinates.each do |coord|
      puts coord.to_s
      if isWallOrSnake?(coord, responseJson)
        puts "wall or snake not keeping"
      else 
        safeAdjacent.push(coord)
      end
    end
    puts "THESE ARE THE SAFE COORDS"
    puts safeAdjacent.to_s
    puts "END SAFE COORDS"
    return safeAdjacent
end

# Orders food by # of moves from to a coordinate
def getOrderedFood(food, coord)
    orderedFood = food.sort_by { |apple| (apple[0] - coord[0]).abs + (apple[1] - coord[1]).abs }
    puts "ORDERED FOOD: " +  orderedFood.to_s
    return orderedFood
end

def getBestMoveInTermsOfFood(orderedFood, moveOptions)
    if moveOptions.empty?
        puts "WE'RE DEAD"
    end

    puts "ORDERED FOOD: " + orderedFood[0].to_s
    targetFood = orderedFood[0]
    orderedMoveOptions = moveOptions.sort_by { |move|  (move[0] - targetFood[0]).abs + (move[1] - targetFood[1]).abs }
    
    bestFoodMove = orderedMoveOptions.first
    puts "BEST FOOD MOVE: " + bestFoodMove.to_s

    return bestFoodMove
end

def getSafestMove(adjacentMoves, requestJson)
    safestMoves = adjacentMoves.sort_by { |move| onlyKeepSafeCoordinates(getAdjacentCoordinates(move), requestJson).size }
    puts "SAFEST MOVES"
    puts safestMoves
    return safestMoves
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

    moveOptions = onlyKeepSafeCoordinates(adjacentCoordinates, requestJson)

    bestMoveCoords = getBestMoveInTermsOfFood(orderedFood, moveOptions)

    getSafestMoves(adjacentCoordinates, requestJson)

    puts "BEST MOVE IS!!"
    puts bestMoveCoords.to_s
    move = getHashKeyDirections(adjacentCoordinates, bestMoveCoords)
    puts "GO: "
    puts move
    responseObject = {
        "move" => move, # One of either "north", "east", "south", or "west".
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
