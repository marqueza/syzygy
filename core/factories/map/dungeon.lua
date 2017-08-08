local Factory = require("core/factories/entity/Factory")
local systems = require "core.systems.systems"
local rot = require "lib.rotLove.src.rot"
local dungeon = {}

dungeon.emptyCoords = {}
local planeName
function dungeon.buildStructure(x, y, value)
  if value == 1 or 
    (x == 1 or x == dungeon.length or
     y == 1 or y == dungeon.width) then
      --systems.addEntity(Factory.Wall{x=x, y=y, plane=planeName})
  else
      --systems.addEntity(Factory.Floor{x=x, y=y, plane=planeName})
      systems.planeSystem:setEmptySpace(x, y, planeName)
    table.insert(dungeon.emptyCoords, x..','..y)
  end
end

function dungeon.build(seed, levelEvent)
  local startTime = love.timer.getTime()
  dungeon.emptyCoords = {}
  planeName = levelEvent.levelName..'-'..levelEvent.levelDepth
  math.randomseed(seed)
  local options = levelEvent.options
  dungeon.length = 20
  dungeon.width = 20

  local rotCellBuilder = rot.Map.Digger(dungeon.length, dungeon.width, {connected=true})
  local rotRng = rot.RNG
  rotRng:setSeed(seed)
  rotCellBuilder:setRNG(rotRng)
  --rotCellBuilder:randomize(.5)
  rotCellBuilder:create(dungeon.buildStructure)
  
  local randX, randY = dungeon.getEmptyCoord()
  local exitX, exitY = randX, randY
  
  if levelDepth == 1 then
  systems.addEntity(Factory.OutsideEntrance{
      levelName = "overWorld",
      x=randX,
      y=randY,
      plane=planeName}) 
  randX, randY = dungeon.getEmptyCoord()
  systems.addEntity(Factory.Goo{x=randX, y=randY, plane=planeName})
else
  systems.addEntity(Factory.Upstairs{
      levelName = "tower",
      x=randX,
      y=randY,
      plane=planeName}) 
  randX, randY = dungeon.getEmptyCoord()
  systems.addEntity(Factory.Goo{x=randX, y=randY, plane=planeName})
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
  
    randX, randY = dungeon.getEmptyCoord()
    systems.addEntity(Factory.Downstairs{
            levelName = levelEvent.levelName,
            x=randX,
            y=randY,
            color=options.color,
            plane=planeName})
  
  
  
  print (math.floor((love.timer.getTime() - startTime)*1000))
end

function dungeon.getEmptyCoord()
  local randomIndex = math.ceil(math.random(1, #dungeon.emptyCoords))
  local coordinateString = dungeon.emptyCoords[randomIndex]
  table.remove(dungeon.emptyCoords, randomIndex)
  local strings = string.gmatch(coordinateString, "%d+")
  local x = tonumber(strings())
  local y = tonumber(strings())
  return x, y
end

return dungeon