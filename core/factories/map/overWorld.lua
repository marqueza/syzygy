local Factory = require("core/factories/entity/Factory")
local systems = require "core.systems.systems"
local rot = require "lib.rotLove.src.rot"

local arena = {}
local planeName
arena.emptyCoords = {}

function arena.buildStructure(x, y, value)
  if value == 1 or 
    (x == 1 or x == arena.length or
     y == 1 or y == arena.width) then
    systems.planeSystem:setFloorSpace(x, y, planeName)
     systems.addEntity(Factory.Water{x=x, y=y, variant="B", plane=planeName})
  else
    --systems.addEntity(Factory.CaveFloor{x=x, y=y, plane=planeName})
    print(planeName)
    systems.planeSystem:setFloorSpace(x, y, planeName)

    table.insert(arena.emptyCoords, x..','..y)
  end
end

function arena.build(seed, levelEvent, options)
    math.randomseed(seed)
    options = options or {}
    arena.length = options.length or 20
    arena.width = options.width or 20
    planeName = levelEvent.levelName..'-'..levelEvent.levelDepth

  local rotCellBuilder = rot.Map.Cellular(arena.length, arena.width, {
                    --born    ={5,6,7,8},
                    --survive ={4,5,6,7,8},
                    topology=4,
                    connected=true,
                    minimumZoneArea=4
                  })
  local rotRng = rot.RNG
  rotRng:setSeed(seed)
  rotCellBuilder:setRNG(rotRng)
  rotCellBuilder:randomize(.7)
  rotCellBuilder:create(arena.buildStructure)

  local randX, randY
  for i=0, math.floor(math.random(1,4)) do
    randX, randY = arena.getEmptyCoord()
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
  for i=0, math.floor(math.random(1,4)) do
    local seed = math.floor(math.random()*10000)
    randX, randY = arena.getEmptyCoord()
    systems.addEntity(
      Factory.Cave{
          levelSeed = seed,
          levelDepth = levelEvent.levelDepth+1,
          x=randX,
          y=randY,
          plane=planeName})
  end
  for i=0, math.floor(math.random(1,4)) do
    local seed = math.floor(math.random()*10000)
    randX, randY = arena.getEmptyCoord()
    systems.addEntity(Factory.Forest{
          levelSeed = seed,
          levelDepth = levelEvent.levelDepth+1,
          x=randX,
          y=randY,
          plane=planeName})
  end
  
    --set player
  randX, randY = arena.getEmptyCoord()
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

function arena.getEmptyCoord()
  local randomIndex = math.ceil(math.random(1, #arena.emptyCoords))
  local coordinateString = arena.emptyCoords[randomIndex]
  table.remove(arena.emptyCoords, randomIndex)
  local strings = string.gmatch(coordinateString, "%d+")
  local x = tonumber(strings())
  local y = tonumber(strings())
  return x, y
end
return arena
