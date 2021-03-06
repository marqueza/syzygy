local Factory = require("core/factories/entity/Factory")
local systems = require "core.systems.systems"
local rot = require "lib.rotLove.src.rot"
local components = require "core.components.components"
local dungeon = {}

dungeon.emptyCoords = {}
local planeName
function dungeon.buildStructure(x, y, value)
  if value == 1 or
    (x == 1 or x == dungeon.length or
     y == 1 or y == dungeon.width) then
  else
      systems.planeSystem:setFloorSpace(x, y, planeName)
  end
end

function dungeon.build(seed, levelEvent)
  assert(levelEvent.levelName)
  local startTime = love.timer.getTime()
  dungeon.emptyCoords = {}
  planeName = levelEvent.levelName..'-'..levelEvent.levelDepth
  math.randomseed(seed)
  local options = levelEvent.options
  dungeon.length = math.random(20, 60)
  dungeon.width = math.random(20, 60)

  local rotDungeonBuilder = rot.Map.Digger(dungeon.length, dungeon.width, {connected=true})
  local rotRng = rot.RNG
  rotRng:setSeed(seed)
  rotDungeonBuilder:setRNG(rotRng)
  rotDungeonBuilder:create(dungeon.buildStructure)
  local doorsList = rotDungeonBuilder:getDoors()
  for index, doorCoord in ipairs(doorsList) do
    systems.addEntity(Factory.WoodDoor{x=doorCoord.x, y=doorCoord.y, plane=planeName})
  end
  local roomList = rotDungeonBuilder:getRooms()
  for index, room in ipairs(roomList) do
      for x = room:getLeft(), room:getRight() do
          for y = room:getTop(), room:getBottom() do
              table.insert(dungeon.emptyCoords, x .. ",".. y)
          end
      end
  end


  local randX, randY = dungeon.getEmptyCoord()
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
  randX, randY = dungeon.getEmptyCoord()
  systems.addEntity(Factory.Goo{x=randX, y=randY, plane=planeName})
  end

  for i=0, math.floor(math.random(0,2)) do
    randX, randY = dungeon.getEmptyCoord()
    systems.addEntity(Factory.Goo{x=randX, y=randY, plane=planeName})
  end
  for i=0, math.floor(math.random(1,3)) do
    randX, randY = dungeon.getEmptyCoord()
    systems.addEntity(Factory.Orc{x=randX, y=randY, plane=planeName})
  end
  if math.random(1,5) == 1 then
    randX, randY = dungeon.getEmptyCoord()
    systems.addEntity(Factory.Angel{x=randX, y=randY, plane=planeName})
  end
  if math.random(1,4) == 1 then
    randX, randY = dungeon.getEmptyCoord()
    systems.addEntity(Factory.Devil{x=randX, y=randY, plane=planeName})
  end
  if math.random(1,3) == 1 then
    randX, randY = dungeon.getEmptyCoord()
    systems.addEntity(Factory.Golem{x=randX, y=randY, plane=planeName})
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
  if math.random(1,3) == 1 then
    randX, randY = dungeon.getEmptyCoord()
    systems.addEntity(Factory.Book{
        x=randX,
        y=randY,
        plane=planeName,
        spellName="Pocket Dimension"})
  end
  if math.random(1,3) == 1 then
    randX, randY = dungeon.getEmptyCoord()
    systems.addEntity(Factory.Scroll{
        x=randX,
        y=randY,
        plane=planeName,
        spellName="Return"})
  end
    randX, randY = dungeon.getEmptyCoord()

    systems.addEntity(Factory.Downstairs{
          levelName = levelEvent.levelName,
          levelSeed = levelEvent.levelSeed+1,
          levelDepth = levelEvent.levelDepth,
          x=randX,
          y=randY,
          plane=planeName})
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
