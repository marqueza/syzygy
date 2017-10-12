local lovetoys = "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local events = require "core.events.events"
local arena = require "core.factories.map.arena"
local lair = require "core.factories.map.lair"
local cavern = require "core.factories.map.cavern"
local forest = require "core.factories.map.forest"
local overWorld = require "core.factories.map.overWorld"
local dungeon = require "core.factories.map.dungeon"
local aiCombatTest = require "core.factories.map.tests.aiCombatTest"

local LevelSystem = class("LevelSystem", System)

--private methods
local _restoreLevel
local _createLevel
local _storeLevel
local _getLevelSeed
local _getLeader
local _getCurrentLevelName
local _getCurrentLevelDepth

function LevelSystem:initialize()
  self.name = "LevelSystem"
  --self.seed = 8
  --self.seed = os.time()*1000000
end

function LevelSystem:onNotify(levelEvent)
  assert(levelEvent.levelName)
  assert(levelEvent.levelDepth)
  --get the leader
  local leader = _getLeader(levelEvent)
  levelEvent.leader = leader
  
  --adjusting the levelEvent's levelDepth
  if levelEvent.options.depthDelta then
    levelEvent.levelDepth = _getCurrentLevelDepth(leader)+levelEvent.options.depthDelta
  end
  
  if leader and leader.Physics.plane then
    levelEvent.oldX = leader.Physics.x
    levelEvent.oldY = leader.Physics.y
  end

  --first level in the game
  if leader == nil then
    --self.currentLevelName = levelEvent.levelName
    overWorld.build(
      _getLevelSeed(levelEvent), 
      levelEvent, 
      {spawnPlayer=true})
    --assert(game.player)
    events.eventManager:fireEvent(events.LogEvent{
        text="You begin your journey in an unknown land. "
      })
    
  --entering an existing level
  elseif self:levelVisited(levelEvent.levelName, levelEvent.levelDepth) then
    events.eventManager:fireEvent(events.LogEvent{
        text="You've been here before." 
      })
    self:reloadLevel(levelEvent)

  --new level replacing old
  else
    events.eventManager:fireEvent(events.LogEvent{
        text="This place is brand new."
      })
    self:enterNewLevel(levelEvent)
  end
  --change levelName
  --self.currentLevelName = levelEvent.levelName
  --change depth
  --self.currentLevelDepth = levelEvent.levelDepth
  --do a full save
  --events.fireEvent(events.SaveEvent{saveSlot="latest", saveType="full", prefix=nil})


end
function LevelSystem:levelVisited(levelName, levelDepth)
  local filePath = systems.saveSystem:getSaveDir() .."/".. levelName.."-"..levelDepth.."_"
  ..systems.saveSystem.gameId..".save.txt"
  if (love.filesystem.exists(filePath)) then
    return true
  else 
    return (systems.planeSystem.planes[levelName .. "-" .. levelDepth] ~= nil)
  end
end

function LevelSystem:reloadLevel(levelEvent)

  local previousEntranceEntity = systems.getEntityById(levelEvent.previousEntranceId)
  assert(levelEvent.levelName)
  assert(levelEvent.levelDepth)

  --store and remove travelers and their inventories
  local travelers = {}
  local travelersItems = {}
  for k, id in pairs(levelEvent.travelerIds) do
    local travelerEntity = systems.getEntityById(id)
    table.insert(travelers, travelerEntity)
    systems.removeEntity(travelerEntity)
    if travelerEntity.Inventory then
      for k, itemId in pairs(travelerEntity.Inventory.itemIds) do
        local itemEntity = systems.getEntityById(itemId)
        table.insert(travelersItems, itemEntity)
        systems.removeEntity(itemEntity)
      end
    end
  end
  local leader = levelEvent.leader
  --save level that is being left
  events.fireEvent(events.SaveEvent{saveSlot="latest", saveType="level", prefix=leader.Physics.plane})

  --recreate the former level
  events.fireEvent(events.LoadEvent{saveSlot="latest", loadType="level", prefix=levelEvent.levelName .."-"..levelEvent.levelDepth})

  local desiredEntranceKey = nil
  local travelX, travelY, travelPlane = nil,nil,nil
  
  --if provided newX and newY, this will determine where to enter in the new level
  if levelEvent.newX and levelEvent.newY then
    travelX = levelEvent.newX
    travelY =levelEvent.newY
    travelPlane = levelEvent.levelName .. "-" .. levelEvent.levelDepth
  
  --when provided an entranceId this will determine where to enter in the new level
elseif levelEvent.previousEntranceId then

    local entrances = systems.getEntitiesWithComponent("Entrance")

    --check if we are entering a new levelName
    if _getCurrentLevelName(leader) ~= levelEvent.levelName then
      --determine where the travelers are going
      for key, entranceEntity in pairs(entrances) do
        if entranceEntity.Entrance.levelName == _getCurrentLevelName(leader) then
          travelX = entranceEntity.Physics.x
          travelY = entranceEntity.Physics.y
          travelPlane = levelEvent.levelName .. "-" .. levelEvent.levelDepth
        end
      end
    else
      if previousEntranceEntity.Entrance.commandKey == "<" then
        desiredEntranceKey = ">"
      elseif previousEntranceEntity.Entrance.commandKey == ">" then
        desiredEntranceKey = "<"
      end
      for key, entranceEntity in pairs(entrances) do
        if entranceEntity.Entrance.commandKey == desiredEntranceKey then
          travelX = entranceEntity.Physics.x
          travelY = entranceEntity.Physics.y
          travelPlane = levelEvent.levelName .. "-" .. levelEvent.levelDepth
        end
      end
    end
  end 

  --bring in all the travelers
  for k, travelerEntity in pairs(travelers) do
    if travelX and travelY then 
      systems.planeSystem:reposition(travelerEntity, travelX, travelY, travelPlane)
    end
    systems.addEntity(travelerEntity)
  end
  --place traveler items
  for k, itemEntity in pairs(travelersItems) do
    systems.addEntity(itemEntity)
  end
end

function LevelSystem:enterNewLevel(levelEvent)
  local previousEntranceEntity = systems.getEntityById(levelEvent.entranceId)

  --store and remove travelers and their inventories
  local travelers = {}
  local travelersItems = {}
  for k, id in pairs(levelEvent.travelerIds) do
    local travelerEntity = systems.getEntityById(id)
    table.insert(travelers, travelerEntity)
    systems.removeEntity(travelerEntity)
    if travelerEntity.Inventory then
      for k, itemId in pairs(travelerEntity.Inventory.itemIds) do
        local itemEntity = systems.getEntityById(itemId)
        table.insert(travelersItems, itemEntity)
        systems.removeEntity(itemEntity)
      end
    end
  end
  local leader = levelEvent.leader
  --save level
  events.fireEvent(events.SaveEvent{saveSlot="latest", saveType="level", prefix=leader.Physics.plane})

  --delete entities
  --systems.removeAllEntities()

  if string.match(levelEvent.levelName,"overWorld") ~= nil then
    overWorld.build(_getLevelSeed(levelEvent), levelEvent)
  elseif string.match(levelEvent.levelName, "tower") or string.match(levelEvent.levelName, "castle") then
      dungeon.build(_getLevelSeed(levelEvent), levelEvent)
  elseif string.match(levelEvent.levelName, "forest") then
    forest.build(_getLevelSeed(levelEvent), levelEvent)
  elseif string.match(levelEvent.levelName, "cave") then
    cavern.build(_getLevelSeed(levelEvent), levelEvent)
  end

  --when provided an entranceId this will determine where to enter in the new level
  local desiredEntranceKey = nil
  local travelX, travelY, travelPlane = nil,nil,nil
  if levelEvent.entranceId then
    --determine desired entrance type

    if previousEntranceEntity.Entrance.commandKey == "<" then
      desiredEntranceKey = ">"
    elseif previousEntranceEntity.Entrance.commandKey == ">" then
      desiredEntranceKey = "<"
    end

    --now attempt to find this desired entrance
    local entrances = systems.getEntitiesWithComponent("Entrance")
    assert(next(entrances))
    local foundMatch = false
    if _getCurrentLevelName(leader) ~= levelEvent.levelName then
      for key, entranceEntity in pairs(entrances) do
        if entranceEntity.Entrance.levelName == _getCurrentLevelName(leader) and
           entranceEntity.Physics.plane == levelEvent.levelName .. "-" .. levelEvent.levelDepth
        then
          travelX = entranceEntity.Physics.x
          travelY = entranceEntity.Physics.y
          travelPlane = levelEvent.levelName .. "-" .. levelEvent.levelDepth
          foundMatch = true
        end
      end
      assert(foundMatch, "Could not link up previous level to an entrance")
    else
      entrances = systems.getEntitiesWithComponent("Entrance")
      for key, entranceEntity in pairs(entrances) do
        if entranceEntity.Entrance.commandKey == desiredEntranceKey and
        entranceEntity.Physics.plane == levelEvent.levelName .. "-" .. levelEvent.levelDepth
        then
          travelX = entranceEntity.Physics.x
          travelY = entranceEntity.Physics.y
          travelPlane = levelEvent.levelName .. "-" .. levelEvent.levelDepth
        end
      end
    end
    
  end  


  --place travelers
  for k, travelerEntity in pairs(travelers) do
    if travelX and travelY then
      systems.planeSystem:reposition(travelerEntity, travelX, travelY, travelPlane)
    end
    systems.addEntity(travelerEntity)
  end
  
  --where ever the travelers ended up we now have to go back and update the previous entrance
  previousEntranceEntity.Entrance.newX = travelX
  previousEntranceEntity.Entrance.newY = travelY

  --place traveler items
  for k, itemEntity in pairs(travelersItems) do
    systems.addEntity(itemEntity)
  end

end

_getLevelSeed = function(levelEvent)
  return (string.match(levelEvent.levelName, "%d+") or 0) + levelEvent.levelDepth
end

_getLeader = function(levelEvent)
  for index, travelerId in ipairs(levelEvent.travelerIds) do
    local traveler = systems.getEntityById(travelerId)
    if traveler and traveler.Party then
      return traveler
    end
  end
end

_getCurrentLevelName = function(leader)
  if leader then
    return string.match(leader.Physics.plane, "(%g+)-")
  else
    return "VOID"
  end
end
_getCurrentLevelDepth = function(leader)
  if leader then
    return string.match(leader.Physics.plane, "-(%d+)")
  else
    return 0
  end
end
return LevelSystem
