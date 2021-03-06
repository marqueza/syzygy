local Factory = require("core/factories/entity/Factory")
local systems = require "core.systems.systems"
local rot = require "lib.rotLove.src.rot"
local dungeon = {}

dungeon.emptyCoords = {}

local planeName
local roomA ={}
roomA.width = 10
roomA.length = 10
roomA.anchorX = 1
roomA.anchorY = 1

local roomB = {}
roomB.width = 10
roomB.length = 10
roomB.anchorX = 15
roomB.anchorY = 1



function dungeon.build(seed, levelEvent)
  local startTime = love.timer.getTime()
  dungeon.emptyCoords = {}
  planeName = levelEvent.levelName..'-'..levelEvent.levelDepth
  math.randomseed(seed)
  local options = levelEvent.options
  dungeon.length = 20
  dungeon.width = 20
  
  dungeon.carveFloor()
  dungeon.getEmptyCoord() -- this is just to make the goo appear in the second room
  local randX, randY = dungeon.getEmptyCoord()
  local exitX, exitY = 2, 2
  
  if levelDepth == 1 then
  systems.addEntity(Factory.OutsideEntrance{
      levelName = "overWorld",
      x=randX,
      y=randY,
      plane=planeName}) 
  randX, randY = dungeon.getEmptyCoord()
  --systems.addEntity(Factory.Goo{x=randX, y=randY, plane=planeName})
else
  systems.addEntity(Factory.Upstairs{
      levelName = "tower",
      x=exitX,
      y=exitY,
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
  
  
  
end

function dungeon.carveFloor()
  --build room A
    for i=roomA.anchorX, roomA.length+roomA.anchorX do
        for j=roomA.anchorY, roomA.width+roomA.anchorY do
            if not (i == 1 or i == roomA.length+roomA.anchorX or j == 1 or j == roomA.width+roomA.anchorY) then
                systems.planeSystem:setFloorSpace(i, j, planeName)
                table.insert(dungeon.emptyCoords, i..','..j)
            end
        end
    end
    
    --build hallway
    for i=roomA.anchorX+roomA.length-1, roomB.anchorX do
      local j = roomA.width/2+roomA.anchorY
      systems.planeSystem:setFloorSpace(i, j, planeName)
      table.insert(dungeon.emptyCoords, i..','..j)
    end
    
    --build room B
    for i=roomB.anchorX, roomB.length+roomB.anchorX do
        for j=roomB.anchorY, roomB.width+roomB.anchorY do
            if not (i == 1 or i == roomB.length+roomB.anchorX or j == 1 or j == roomB.width+roomB.anchorY) then
                systems.planeSystem:setFloorSpace(i, j, planeName)
                table.insert(dungeon.emptyCoords, i..','..j)
            end
        end
    end
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