local Factory = require("core/factories/entity/Factory")
local systems = require "core.systems.systems"
local components = require "core.components.components"
local rot = require "lib.rotLove.src.rot"
local cavern = {}

cavern.emptyCoords = {}
local planeName
function cavern.buildStructure(x, y, value)
  if value == 1 or 
    (x == 1 or x == cavern.length or
     y == 1 or y == cavern.width) then
     -- systems.addEntity(Factory.CaveWall{x=x, y=y, variant="B", plane=planeName})
  else
    --systems.addEntity(Factory.CaveFloor{x=x, y=y, plane=planeName})
    systems.planeSystem:setFloorSpace(x, y, planeName)

    table.insert(cavern.emptyCoords, x..','..y)
  end
end

function cavern.build(seed, levelEvent)
  local startTime = love.timer.getTime()
  cavern.emptyCoords = {}
  planeName = levelEvent.levelName..'-'..levelEvent.levelDepth
  math.randomseed(seed)
  local options = levelEvent.options
  cavern.length = math.random(20, 60)
  cavern.width = math.random(20, 60)

  local rotCellBuilder = rot.Map.Cellular(cavern.length, cavern.width, {
                    born    ={5,6,7,8},
                    survive ={4,5,6,7,8},
                    topology=8,
                    connected=true,
                    minimumZoneArea=2
                  })
  local rotRng = rot.RNG
  rotRng:setSeed(seed)
  rotCellBuilder:setRNG(rotRng)
  rotCellBuilder:randomize(.5)
  rotCellBuilder:create(cavern.buildStructure)
  
  local randX, randY = cavern.getEmptyCoord()
  local exitX, exitY = randX, randY
  if levelEvent.levelDepth == 1 then
    systems.addEntity(Factory.OutsideEntrance{
        levelName = "overWorld",
        levelSeed = levelEvent.levelSeed-1,
        levelDepth = levelEvent.levelDepth,
        newX = levelEvent.oldX,
        newY = levelEvent.oldY,
        x=randX,
        y=randY,
        plane=planeName}) 
  else
    systems.addEntity(Factory.Upstairs{
        levelName = levelEvent.levelName,
        levelSeed = levelEvent.levelSeed-1,
        levelDepth = levelEvent.levelDepth,
        newX = levelEvent.oldX,
        newY = levelEvent.oldY,
        x=randX,
        y=randY,
        plane=planeName})
  end
  
  
  --monsters
  for i=0, math.floor(math.random(1,2)) do
    randX, randY = cavern.getEmptyCoord()
    systems.addEntity(Factory.Goo{x=randX, y=randY, plane=planeName})
  end
  for i=0, math.floor(math.random(1,4)) do
    randX, randY = cavern.getEmptyCoord()
    systems.addEntity(Factory.Skeleton{x=randX, y=randY, plane=planeName})
  end
    for i=0, math.floor(math.random(1,2)) do
    randX, randY = cavern.getEmptyCoord()
    systems.addEntity(Factory.Kobold{x=randX, y=randY, plane=planeName})
  end
    for i=0, math.floor(math.random(1,2)) do
    randX, randY = cavern.getEmptyCoord()
    systems.addEntity(Factory.Ghost{x=randX, y=randY, plane=planeName})
  end
  
  --downstairs
  if levelEvent.levelDepth > 2 then
    randX, randY = cavern.getEmptyCoord()
    local boss = Factory.RedGoo{x=randX, y=randY, plane=planeName}
    boss:add(components.Boss{})
    systems.addEntity(boss)
  else
    randX, randY = cavern.getEmptyCoord()
    systems.addEntity(Factory.Downstairs{
          levelName = levelEvent.levelName,
          levelSeed = levelEvent.levelSeed+1,
          levelDepth = levelEvent.levelDepth,
          x=randX,
          y=randY,
          plane=planeName}) 
      randX, randY = cavern.getEmptyCoord()
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
  
  
    randX, randY = cavern.getEmptyCoord()
    systems.addEntity(Factory.Book{
        x=randX,
        y=randY,
        plane=planeName,
        spellName="Return"})

  
  for i=1, 10 do
    randX, randY = cavern.getEmptyCoord()
    if levelEvent.levelName == "forest" then
      systems.addEntity(Factory.Tree{x=randX, y=randY, plane=planeName})       
    else
      systems.addEntity(Factory.Rock{x=randX, y=randY, plane=planeName})        
    end
  end
  
  print (math.floor((love.timer.getTime() - startTime)*1000))
end

function cavern.getEmptyCoord()
  local randomIndex = math.ceil(math.random(1, #cavern.emptyCoords))
  local coordinateString = cavern.emptyCoords[randomIndex]
  table.remove(cavern.emptyCoords, randomIndex)
  local strings = string.gmatch(coordinateString, "%d+")
  local x = tonumber(strings())
  local y = tonumber(strings())
  return x, y
end

return cavern
