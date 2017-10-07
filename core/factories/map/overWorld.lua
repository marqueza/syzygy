local Factory = require("core/factories/entity/Factory")
local systems = require "core.systems.systems"

local arena = {}
arena.emptyCoords = {}

function arena.build(seed, levelEvent, options)
    math.randomseed(seed)
    options = options or {}
    arena.length = options.length or 10
    arena.width = options.width or 7
    local planeName = levelEvent.levelName..'-'..levelEvent.levelDepth

    --build basic map
    for i=1, arena.length do
        for j=1, arena.width do
            if i == 1 or i == arena.length or j == 1 or j == arena.width then
                if i == 1 and j ==1 then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="up", isCorner=true, plane=planeName})
                elseif i == arena.length and j == 1 then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="right", isCorner=true, plane=planeName})
                elseif i == 1 and j == arena.width then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="left", isCorner=true, plane=planeName})
                elseif i == arena.length and j == arena.width then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="down", isCorner=true, plane=planeName})
                elseif i == 1 then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="left", isCorner=false, plane=planeName})
                elseif i == arena.length then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="right", isCorner=false, plane=planeName})
                elseif j == 1 then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="up", isCorner=false, plane=planeName})
                elseif j == arena.width then
                    systems.addEntity(Factory.Shore{x=i, y=j, direction="down", isCorner=false, plane=planeName})
                end
            else
                --systems.addEntity(Factory.Grass{x=i, y=j, plane=planeName})
                table.insert(arena.emptyCoords, i..','..j)
            end
            systems.planeSystem:setFloorSpace(i, j, planeName)
        end
    end

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
