local class = require "lib.middleclass"
local events = require "core.events.events"
local systems = require "core.systems.systems"
local Serializable = require "data.serializable"
local rot = require "lib.rotLove.src.rot"

local AiSystem = class("AiSystem", System)
AiSystem:include(Serializable)

function AiSystem:initialize()
  self.name = "AiSystem"
  self.path = {}
end

local _determineState

function AiSystem:onTurnNotify(TurnEvent)
  --go through all the entities with Ai and have them act
  for aiEntityId, aiEntity in pairs(systems.getEntitiesWithComponent("Ai")) do
    --have them enter the decisionState to decide what to actually do
    _determineState(self, aiEntity)
  end

end

_determineState = function(self, aiEntity)
  --access the objective
  if aiEntity.Ai.objective == "dungeon" then
    if self:combatAction(aiEntity) then 
      return 
    end
    if aiEntity == game.player then
      if self:exploreAction(aiEntity) then return end
    end
    if self:collectAction(aiEntity) then return end
    if self:delveAction(aiEntity) then return end
    
  events.fireEvent(events.LogEvent{text=aiEntity.name.." did not dungeon"})
  elseif aiEntity.Ai.objective == "kill" then
    if self:combatAction(aiEntity) then return end
  elseif aiEntity.Ai.objective == "go" then
    if self:goAction(aiEntity) then return end
  elseif aiEntity.Ai.objective == "collect" then
    if self:collectAction(aiEntity) then return end
  else
    self:idleAction(aiEntity)
  end
end
function AiSystem:exploreAction(aiEntity)
  self.path = {}
  self:pathToUnknown(aiEntity)
  if #(self.path) > 0 then 
    self:followPath(aiEntity) return true
  end
  return false
end

function AiSystem:delveAction(aiEntity)
  self.path = {}
  self:pathToExit(aiEntity)
  if #(self.path) > 0 then 
    self:followPath(aiEntity) 
    aiEntity.Ai.lastAction = "delve"
    return true
  end
end

function AiSystem:collectAction(aiEntity)
  self.path = {}
  self:pathToItem(aiEntity)
  if #(self.path) > 0 then 
    self:followPath(aiEntity) 
    aiEntity.Ai.lastAction = "collect"
    return true
  end
  --check ground for item
  --attempt to pick up
  if self:pickUpItem(aiEntity) then 
    aiEntity.Ai.lastAction = "collect"
    return true 
  end
  --path to harvest spot
  self.path = {}
  self:pathToHarvest(aiEntity)
  if #(self.path) > 0 then 
    self:followPath(aiEntity) 
    aiEntity.Ai.lastAction = "collect"
    return true
  end
  if self:doHarvest(aiEntity) then 
    aiEntity.Ai.lastAction = "collect"
    return true 
  end
  return false
end

function AiSystem:goAction(aiEntity)
  self.path = {}
  self:pathToEntity(aiEntity, game.player)
  if #(self.path) > 1 then 
    self:followPath(aiEntity) 
    aiEntity.Ai.lastAction = "go"
    return true
  end
end

function AiSystem:idleAction(aiEntity)
  AiSystem.MoveEntityToCoord(
    aiEntity, 
    aiEntity.Physics.x+math.floor(math.random(-1,1)), 
    aiEntity.Physics.y+math.floor(math.random(-1,1))
  )
end

function AiSystem:followPath(aiEntity)
  local coord = self.path[#self.path]
  table.remove(self.path)
  local pos = coord:split(',')
  local x = tonumber(pos[1])
  local y = tonumber(pos[2])
  AiSystem.MoveEntityToCoord(aiEntity, x, y)
end
function AiSystem.passableCallback(x, y, plane) 
  local floor = systems.planeSystem:isFloorSpace(x, y, plane)
  if floor then
    local eList = systems.planeSystem:getEntityList(x, y, nil, plane)
    for entity in ipairs(eList) do
      if entity.Physics.blocks then
        return false
      end
    end
  end
  return true
end

function AiSystem.dijikstraCallBack(x, y) 
  table.insert(self.path, x..","..y)
end

function AiSystem:buildPath(aiEntity, endX, endY)
  local passableCallback = function (x, y)
    local floor = systems.planeSystem:isFloorSpace(x, y, aiEntity.Physics.plane)
    if not floor then return false end
    local eList = systems.planeSystem:getEntityList(x, y, "creature", aiEntity.Physics.plane)

    for k, entity in pairs(eList) do
      if entity.Faction.name == aiEntity.Faction.name and 
      not (aiEntity.Follower and entity.id == aiEntity.Follower.leaderId) then
        return false
      end
    end

    return true
  end
  self.dijkstra=rot.Path.Dijkstra(aiEntity.Physics.x, aiEntity.Physics.y, passableCallback)
  self.path = {}
  self.dijkstra:compute(endX, endY, function(x,y) table.insert(self.path, x..","..y) end )
  local coord = self.path[#self.path]
  if not coord then
    return false
  end
  local pos = coord:split(',')
  local x = tonumber(pos[1])
  local y = tonumber(pos[2])
  if x == aiEntity.Physics.x and y == aiEntity.Physics.y then
    table.remove(self.path)
  end
  if #(self.path) > 0 then
    return true
  else
    return false
  end
end
function AiSystem:pathToExit(aiEntity)
  --get me a downstairs in this plane
  local entrances = systems.getEntitiesWithComponent("Entrance")
  for key, entrance in pairs(entrances) do
    if entrance.Entrance.commandKey == ">" then
      if aiEntity.Physics.x == entrance.Physics.x and 
      aiEntity.Physics.y == entrance.Physics.y and 
      aiEntity.Physics.plane == entrance.Physics.plane then
        --fire a level event
        local travelerIds
        if aiEntity.Party then 
          travelerIds=systems.partySystem.getMemberIds(aiEntity)
        else
          travelerIds = {aiEntity.id}
        end
        assert(aiEntity.Party, "Entity " .. aiEntity.name..""..aiEntity.id.."requires 'Party' component")
        events.fireEvent(events.LevelEvent{
            levelName=entrance.Entrance.levelName, 
            levelSeed=entrance.Entrance.levelSeed,
            levelDepth=entrance.Entrance.levelDepth,
            newX=entrance.Entrance.newX,
            newY=entrance.Entrance.newY,
            entranceId=entrance.id,
            options={depthDelta=1},
            travelerIds=travelerIds})
      end
      if aiEntity.Physics.plane == entrance.Physics.plane then
        AiSystem:buildPath(aiEntity, entrance.Physics.x, entrance.Physics.y)
        return true
      end
    end
  end
  return false
end

function AiSystem:pathToHarvest(aiEntity)
  --get me a downstairs in this plane
  local resources = systems.getEntitiesWithComponent("Harvest")
  for key, resource in pairs(resources) do
    if aiEntity.Physics.plane == resource.Physics.plane then
      self:buildPath(aiEntity, resource.Physics.x, resource.Physics.y)
      return true
    end
  end
  return false
end

function AiSystem:pathToItem(aiEntity)
  --get me a downstairs in this plane
  for itemCoord, itemIdList in pairs(systems.planeSystem.planes[aiEntity.Physics.plane]["item"] or {}) do
    --local item = systems.getEntityById(itemId)
    if itemCoord ~= "-1,-1" then
      AiSystem:buildPath(aiEntity, 
        tonumber(string.split(itemCoord, ",")[1]),
        tonumber(string.split(itemCoord, ",")[2]))
      return true
    end
  end
  return false
end

function AiSystem:pathToUnknown(aiEntity)
  for key, value in pairs(systems.planeSystem.planes[aiEntity.Physics.plane]["known"] or {}) do
    local pos = key:split(',')
    local peekX = tonumber(pos[1])
    local peekY = tonumber(pos[2])
    if systems.planeSystem:isFloorSpace(peekX, peekY, aiEntity.Physics.plane) then
      --check all neighbooring squares
      for dx=-1, 1, 1 do
        for dy=-1, 1, 1 do
          --if not (dx==0 and dy==0) then
          local peekPeekX = peekX+dx
          local peekPeekY = peekY+dy
          --if the tile is unknown
          if not systems.planeSystem:isKnownSpace(peekPeekX, peekPeekY, aiEntity.Physics.plane) then
            return self:buildPath(aiEntity, peekX, peekY)
          end
        end
      end
    end
  end
  return false
end
function AiSystem.MoveEntityToCoord(actorEntity, x, y)
  local dx, dy = 0, 0
  if actorEntity.Physics.x > x then
    dx = -1
  elseif actorEntity.Physics.x < x then
    dx = 1
  end
  if actorEntity.Physics.y > y then
    dy = -1
  elseif actorEntity.Physics.y < y then
    dy = 1
  end
  events.fireEvent(events.MoveEvent( {
        moverId=actorEntity.id,
        x=actorEntity.Physics.x + dx,
        y=actorEntity.Physics.y + dy,
      }))
  return
end
function AiSystem:MoveEntityTo(actorEntity, targetEntity)
  --determine direction
  local dx, dy = 0, 0
  if actorEntity.Physics.x > targetEntity.Physics.x then
    dx = -1
  elseif actorEntity.Physics.x < targetEntity.Physics.x then
    dx = 1
  end
  if actorEntity.Physics.y > targetEntity.Physics.y then
    dy = -1
  elseif actorEntity.Physics.y < targetEntity.Physics.y then
    dy = 1
  end

  events.fireEvent(events.MoveEvent( {
        moverId=actorEntity.id,
        x=actorEntity.Physics.x + dx,
        y=actorEntity.Physics.y + dy,
      }))
  return
end

function AiSystem:combatAction(aiEntity)
  self.path = {}
  self:pathToEnemy(aiEntity)
  if #(self.path) > 0 then 
    self:followPath(aiEntity) 
    aiEntity.Ai.lastAction = "combat"
    return true
  end
  return false
end
function AiSystem:pathToEnemy(aiEntity)
  -- if we are in plane sight than everything is fair game. 
  -- if not then we have to see how far the enemy is
  local entityList = systems.getEntitiesWithComponent("Faction")
    if entityList then
      for k, entity in pairs(entityList) do
        if aiEntity.Physics.plane == entity.Physics.plane and aiEntity.Faction.name ~= entity.Faction.name then
          
          --now check the distance. lets say 8
          local dx = entity.Physics.x - entity.Physics.x
          local dy = aiEntity.Physics.y - entity.Physics.y
          local r = math.sqrt(math.pow(dx, 2)+math.pow(dy, 2))
          if r <= 6 then
            return self:buildPath(aiEntity, entity.Physics.x, entity.Physics.y)
          elseif r <= 8 and math.random(1,2)==1 then
            return self:buildPath(aiEntity, entity.Physics.x, entity.Physics.y)
          end
        end
      end
    end
  
  
  --[[
  for key, value in pairs(systems.planeSystem.planes[aiEntity.Physics.plane]["visible"] or {}) do
    local entityList = systems.planeSystem.planes[aiEntity.Physics.plane]["creature"][key]
    if entityList then
      for k, entity in pairs(entityList) do
        --if monster is opposing faction, move/attack it
        if aiEntity.Faction.name ~= entity.Faction.name then
          return self:buildPath(aiEntity, entity.Physics.x, entity.Physics.y)
        end
      end
    end
  end
  --]]
end
function AiSystem:pathToEntity(aiEntity, target)
  return self:buildPath(aiEntity, target.Physics.x, target.Physics.y)
end
function AiSystem:pickUpItem(aiEntity)
  local item = systems.planeSystem:getTopEntity(aiEntity.Physics.x, aiEntity.Physics.y, "item", aiEntity.Physics.plane)
    if item then
      events.fireEvent(
        events.InventoryEnterEvent{
          itemId=item.id,
          holderId=aiEntity.id
        }
      )
      events.fireEvent(events.LogEvent{text=aiEntity.name .. " picks up " .. item.name .. "."})
      return true
    else
      return false
    end
end

function AiSystem:doHarvest(aiEntity)
  local resource = systems.planeSystem:getTopEntity(aiEntity.Physics.x, aiEntity.Physics.y, "backdrop", aiEntity.Physics.plane)
    if resource and resource.Harvest then
      events.fireEvent(
        events.HarvestEvent{
          entityId=resource.id
        }
      )
      events.fireEvent(events.LogEvent{text=aiEntity.name .. " harvests the " .. resource.name .. "."})

      return true
    else
      return false
    end
end

return AiSystem
