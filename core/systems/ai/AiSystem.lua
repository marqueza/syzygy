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
    if self:combatAction(aiEntity) then return end
    if self:exploreAction(aiEntity) then return end
  elseif aiEntity.Ai.objective == "kill" then
    if self:combatAction(aiEntity) then return end
  elseif aiEntity.Ai.objective == "go" then
    if self:goAction(aiEntity) then return end
  else
    self:idleAction(aiEntity)
  end
end
function AiSystem:exploreAction(aiEntity)
  self.path = {}
    self:pathToUnknown(aiEntity)
    if #(self.path) > 0 then 
      self:followPath(aiEntity) return
    end
  self.path = {}
    self:pathToExit(aiEntity)
    if #(self.path) > 0 then 
      self:followPath(aiEntity) return
    end
end

function AiSystem:goAction(aiEntity)
  self.path = {}
  self:pathToEntity(aiEntity, game.player)
  if #(self.path) > 1 then 
      self:followPath(aiEntity) return
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
function AiSystem.passableCallback(x, y) 
  local floor = systems.planeSystem:isFloorSpace(x, y, game.player.Physics.planeName)
  if floor then
    local eList = systems.planeSystem:getEntityList(x, y, nil, game.player.Physics.planeName)
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
        local floor = systems.planeSystem:isFloorSpace(x, y, game.player.Physics.plane)
  if not floor then return false end
    local eList = systems.planeSystem:getEntityList(x, y, "creature", game.player.Physics.plane)
    
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
  if #(self.path) < 0 then
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
        if aiEntity.Physics.x == entrance.Physics.x and aiEntity.Physics.y == entrance.Physics.y then
          --fire a level event
          events.fireEvent(events.LevelEvent{
              levelName=entrance.Entrance.levelName, 
              entranceId=entrance.id,
              options={depthDelta=1},
              travelerIds={systems.partySystem.getMemberIds(aiEntity) or aiEntity.id}})
        end
        AiSystem:buildPath(aiEntity, entrance.Physics.x, entrance.Physics.y)
        return true
      end
    end
    return false
end

function AiSystem:pathToUnknown(aiEntity)
  for key, value in pairs(systems.planeSystem.planes[aiEntity.Physics.plane]["known"]) do
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
      return true
    end
    return false
  end
function AiSystem:pathToEnemy(aiEntity)
  for key, value in pairs(systems.planeSystem.planes[aiEntity.Physics.plane]["visible"]) do
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
  end
  function AiSystem:pathToEntity(aiEntity, target)
    return self:buildPath(aiEntity, target.Physics.x, target.Physics.y)
  end

  return AiSystem
