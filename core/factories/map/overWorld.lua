local Factory = require("core/factories/entity/Factory")
local systems = require "core.systems.systems"
local rot = require "lib.rotLove.src.rot"

local surface = {}
local planeName
surface.emptyCoords = {}

function surface.buildStructure(x, y, value)
  if value == 1 or 
    (x == 1 or x == surface.length or
     y == 1 or y == surface.width) then
    systems.planeSystem:setFloorSpace(x, y, planeName)
    systems.addEntity(Factory.Water{x=x, y=y, plane=planeName})
  else
    systems.planeSystem:setFloorSpace(x, y, planeName)
    systems.addEntity(Factory.Grass{x=x, y=y, plane=planeName})
    table.insert(surface.emptyCoords, x..','..y)
  end
end

function surface.buildShores()
  for x=1,surface.length do
    for y=1,surface.width do 
      --find a water
      --search adjacent spaces
      local entity = systems.planeSystem:getTopEntity(x, y, "floor", planeName)
      if entity and entity.name == "water" then
        --count the grass nearby

        local shoreKey = ""
            if y >= 2 and 
              systems.planeSystem:getTopEntity(x, y-1, "floor", planeName) and
              systems.planeSystem:getTopEntity(x, y-1, "floor", planeName).name == "grass" then
              shoreKey = shoreKey .. "A"
            end
            if x >= 2 and  systems.planeSystem:getTopEntity(x-1, y, "floor",  planeName) and
              systems.planeSystem:getTopEntity(x-1, y, "floor", planeName).name =="grass" then
              shoreKey = shoreKey .. "B"
            end
            if x <= surface.width+1 and systems.planeSystem:getTopEntity(x+1, y,"floor",  planeName) and
              systems.planeSystem:getTopEntity(x+1, y, "floor", planeName).name =="grass" then
              shoreKey = shoreKey .. "C"
            end
            if y <= surface.length+1 and systems.planeSystem:getTopEntity(x, y+1, "floor", planeName) and
              systems.planeSystem:getTopEntity(x, y+1, "floor", planeName).name =="grass" then
              shoreKey = shoreKey .. "D"
            end
            if x >= 2 and y >=2 and not string.match(shoreKey, "A") and not string.match(shoreKey, "B") and
              systems.planeSystem:getTopEntity(x-1, y-1, "floor", planeName) and
              systems.planeSystem:getTopEntity(x-1, y-1, "floor", planeName).name == "grass" then
              shoreKey = shoreKey .. "1"
            end
            if y >= 2 and x <=surface.length and not string.match(shoreKey, "A") and not string.match(shoreKey, "C") and
              systems.planeSystem:getTopEntity(x+1, y-1, "floor", planeName) and
              systems.planeSystem:getTopEntity(x+1, y-1, "floor", planeName).name == "grass" then
              shoreKey = shoreKey .. "2"
            end
            if x >= 2 and y <=surface.length and not string.match(shoreKey, "B") and not string.match(shoreKey, "D") and
              systems.planeSystem:getTopEntity(x-1, y+1, "floor", planeName) and
              systems.planeSystem:getTopEntity(x-1, y+1, "floor", planeName).name == "grass" then
              shoreKey = shoreKey .. "3"
            end
            if x <= surface.width and y <=surface.length and not string.match(shoreKey, "C") and not string.match(shoreKey, "D") and
              systems.planeSystem:getTopEntity(x+1, y+1, "floor", planeName) and
              systems.planeSystem:getTopEntity(x+1, y+1, "floor", planeName).name == "grass" then
              shoreKey = shoreKey .. "4"
            end
            if shoreKey == "ABCD" then
              systems.removeEntity(entity)
            elseif shoreKey ~="" then
              systems.removeEntity(entity)
              systems.addEntity(Factory.Shore{x=x, y=y, plane=planeName, shoreKey=shoreKey})
            end
      end
    end
  end
 end

function surface.build(seed, levelEvent, options)
    math.randomseed(seed)
    options = options or {}
    surface.length = options.length or 20
    surface.width = options.width or 20
    planeName = levelEvent.levelName..'-'..levelEvent.levelDepth

  local rotCellBuilder = rot.Map.Cellular(surface.length, surface.width, {
                    born    ={5,6,7,8},
                    survive ={4,5,6,7,8},
                    topology=4,
                    connected=true,
                    minimumZoneArea=4
                  })
  local rotRng = rot.RNG
  rotRng:setSeed(seed+os.time())
  rotCellBuilder:setRNG(rotRng)
  rotCellBuilder:randomize(.77)
  rotCellBuilder:create(surface.buildStructure)
  surface.buildShores()

  local randX, randY
  for i=0, math.floor(math.random(1,4)) do
    randX, randY = surface.getEmptyCoord()
    local seed = math.floor(math.random()*10000)
    systems.addEntity(
      Factory.Castle{
          levelSeed = seed,
          levelDepth = levelEvent.levelDepth+1,
          x=randX,
          y=randY,
          plane=planeName}
        )
  end
  for i=0, math.floor(math.random(5,20)) do
    local seed = math.floor(math.random()*10000)
    randX, randY = surface.getEmptyCoord()
    systems.addEntity(
      Factory.Cave{
          levelSeed = seed,
          levelDepth = levelEvent.levelDepth+1,
          x=randX,
          y=randY,
          plane=planeName})
  end
  for i=0, math.floor(math.random(5,20)) do
    local seed = math.floor(math.random()*10000)
    randX, randY = surface.getEmptyCoord()
    systems.addEntity(Factory.Forest{
          levelSeed = seed,
          levelDepth = levelEvent.levelDepth+1,
          x=randX,
          y=randY,
          plane=planeName})
  end
  
    --set player
  randX, randY = surface.getEmptyCoord()
  if options.spawnPlayer then
    game.player = Factory.Player{x=randX,y=randY, plane=planeName}
    systems.addEntity(game.player)
    assert(game.player)
  end
  if options.spawnMinion then
    game.player = Factory.Brownie{x=randX,y=randY, plane=planeName}
    systems.addEntity(game.player)
  end
end

function surface.getEmptyCoord()
  local randomIndex = math.ceil(math.random(1, #surface.emptyCoords))
  local coordinateString = surface.emptyCoords[randomIndex]
  table.remove(surface.emptyCoords, randomIndex)
  local strings = string.gmatch(coordinateString, "%d+")
  local x = tonumber(strings())
  local y = tonumber(strings())
  return x, y
end
return surface
