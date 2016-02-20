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

# def getSnakeCoords(snakes)
#     coords = []
#     snakes.each do |snake|
#         coords.push(snake[:coords].flatten!)
#     end
#     puts coords
# end  
# def isWAll?(coordinate, )

# end

# def isSnake?(coordinate,  )
# def isWallOrSnake(requestJSON)
#     snakeArray = requestJSON["snakes"]
#     coordsArray = []
#     snakeArray.each do |x|
#         coordsArray.push(x["coords"].flatten!)
#     end
#     # snakeCoords = snakeArray.map{|x| x[:"coord"]}
#     puts coordsArray
#     # snakes = 
# # def isWallOrSnake(requestJSON)
# #     snakeArray = requestJSON["snakes"]
# #     snakeCoords = snakeArray.map{|x| x[:"coord"]}
# #     puts snakeArray
# #     # snakes = 
# end

# Orders food by # of moves from to a coordinate
def getOrderedFood(food, coord)
    puts "WE ARE GETTING ORDERED FOOD"
    orderedFood = food.sort_by { |apple| (apple[0] - coord[0]) + (apple[1] - coord[1]) }
    puts "FOOD"
    print food
    puts "ORDERED FOOD"
    print orderedFood
end

get '/' do
    responseObject = {
        "color"=> "#fff111",
        "head_url"=> "url/to/your/img/file"
    }

    return responseObject.to_json
end

post '/start' do
    puts "OKAY WE ARE STATREYAKDFLFJ"
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
    # getAdjacentCoordinates(boomslang["coords"][0])

    getOrderedFood(requestJson["food"], boomslangHead)

    # isWallOrSnake(requestJSON)
    # getSnakeCoords(requestJson["snakes"])
    
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
