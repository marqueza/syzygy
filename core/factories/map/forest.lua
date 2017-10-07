local Factory = require("core/factories/entity/Factory")
local systems = require "core.systems.systems"
local rot = require "lib.rotLove.src.rot"
local forest = {}

forest.emptyCoords = {}
local planeName
function forest.buildStructure(x, y, value)
  if value == 1 or 
    (x == 1 or x == forest.length or
     y == 1 or y == forest.width) then
     -- systems.addEntity(Factory.CaveWall{x=x, y=y, variant="B", plane=planeName})
  else
    --systems.addEntity(Factory.CaveFloor{x=x, y=y, plane=planeName})
    systems.planeSystem:setFloorSpace(x, y, planeName)
    table.insert(forest.emptyCoords, x..','..y)
  end
end

function forest.build(seed, levelEvent)
  local startTime = love.timer.getTime()
  forest.emptyCoords = {}
  planeName = levelEvent.levelName..'-'..levelEvent.levelDepth
  math.randomseed(seed)
  local options = levelEvent.options
  forest.length = 20
  forest.width = 20

  local rotCellBuilder = rot.Map.Cellular(forest.length, forest.width, {connected=true})
  local rotRng = rot.RNG
  rotRng:setSeed(seed)
  rotCellBuilder:setRNG(rotRng)
  rotCellBuilder:randomize(.5)
  rotCellBuilder:create(forest.buildStructure)
  
  local randX, randY = forest.getEmptyCoord()
  local exitX, exitY = randX, randY
  if levelEvent.levelDepth == 1 then
    systems.addEntity(Factory.OutsideEntrance{
        levelName = "overWorld",
        levelSeed = levelEvent.levelSeed-1,
        levelDepth = 0,
        newX = levelEvent.oldX,
        newY = levelEvent.oldY,
        x=randX,
        y=randY,
        plane=planeName}) 
  else
    systems.addEntity(Factory.Upstairs{
        levelName = levelEvent.levelName,
        levelSeed = levelEvent.levelSeed-1,
        levelDepth = levelEvent.levelDepth-1,
        newX = levelEvent.oldX,
        newY = levelEvent.oldY,
        x=randX,
        y=randY,
        plane=planeName}) 
  end
  
  
  --monsters
  for i=0, math.floor(math.random(1,2)) do
    randX, randY = forest.getEmptyCoord()
    systems.addEntity(Factory.Brownie{x=randX, y=randY, plane=planeName})
  end
  for i=0, math.floor(math.random(1,4)) do
    randX, randY = forest.getEmptyCoord()
    systems.addEntity(Factory.Fairy{x=randX, y=randY, plane=planeName})
  end
  
  --downstairs
  if levelEvent.levelDepth > 2 then
    randX, randY = forest.getEmptyCoord()
    systems.addEntity(Factory.Medal{x=randX, y=randY, plane=planeName})
  else
    randX, randY = forest.getEmptyCoord()
    systems.addEntity(Factory.Downstairs{
          levelName = levelEvent.levelName,
          levelSeed = levelEvent.levelSeed+1,
          levelDepth = levelEvent.levelDepth+1,
          x=randX,
          y=randY,
          plane=planeName}) 
      randX, randY = forest.getEmptyCoord()
  end
  
  --set player
  if options.spawnPlayer then
    game.player = Factory.Player{x=exitX,y=exitY, plane=planeName}
    systems.addEntity(game.player)
  end
  if options.spawnMinion then
    game.player = Factory.Brownie{x=exitX,y=exitY, plane=planeName}
    systems.addEntity(game.player)
  end
  
  for i=1, 10 do
    randX, randY = forest.getEmptyCoord()
    systems.addEntity(Factory.Tree{x=randX, y=randY, plane=planeName})
  end
end

function forest.getEmptyCoord()
  local randomIndex = math.ceil(math.random(1, #forest.emptyCoords))
  local coordinateString = forest.emptyCoords[randomIndex]
  table.remove(forest.emptyCoords, randomIndex)
  local strings = string.gmatch(coordinateString, "%d+")
  local x = tonumber(strings())
  local y = tonumber(strings())
  return x, y
end

return forest
