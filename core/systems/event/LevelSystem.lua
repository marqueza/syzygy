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

function LevelSystem:initialize()
  self.name = "LevelSystem"
  --self.seed = 8
  self.seed = os.time()*1000000
  self.currentLevelName = nil
  self.currentLevelDepth = 1
end

function LevelSystem:onNotify(levelEvent)

  --adjusting the levelEvent's levelDepth
  if levelEvent.options.depthDelta then
    levelEvent.levelDepth = self.currentLevelDepth+levelEvent.options.depthDelta
  end

  assert(levelEvent.levelName)
  assert(levelEvent.levelDepth)

  --if provided an entrance, mark it opened
  if levelEvent.entranceId then
    local entranceEntity = systems.getEntityById(levelEvent.entranceId)
    entranceEntity.Entrance.isOpened = true
  end

  --first level in the game
  if self.currentLevelName == nil then
    self.currentLevelName = levelEvent.levelName
    overWorld.build(
      _getLevelSeed(self, levelEvent), 
      levelEvent, 
      {spawnPlayer=true})
    assert(game.player)
    events.eventManager:fireEvent(events.LogEvent{
        text="You begin your journey in an unknown land. "
      })
    --entering an existing level
  elseif self:levelVisited(levelEvent.levelName,levelEvent.levelDepth) then
    events.eventManager:fireEvent(events.LogEvent{
        text="You've been here before." 
      })
    self:reloadLevel(levelEvent.levelName, levelEvent.levelDepth, levelEvent.travelerIds, levelEvent.entranceId)

    --new level replacing old
  else
    events.eventManager:fireEvent(events.LogEvent{
        text="This place is brand new."
      })
    self:enterNewLevel(levelEvent)
  end
  --change levelName
  self.currentLevelName = levelEvent.levelName
  --change depth
  self.currentLevelDepth = levelEvent.levelDepth
  --do a full save
  --events.fireEvent(events.SaveEvent{saveSlot="latest", saveType="full", prefix=nil})


end
function LevelSystem:levelVisited(levelName, levelDepth)
  local filePath = systems.saveSystem:getSaveDir() .."/".. levelName.."-"..levelDepth.."_"
  ..systems.saveSystem.gameId..".save.txt"
  return love.filesystem.exists(filePath)
end
function LevelSystem:reloadLevel(levelName, levelDepth, travelerIds, previousEntranceId)

  local previousEntranceEntity = systems.getEntityById(previousEntranceId)
  assert(levelName)
  assert(levelDepth)

  --store and remove travelers and their inventories
  local travelers = {}
  local travelersItems = {}
  for k, id in pairs(travelerIds) do
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

  --save level that is being left
  events.fireEvent(events.SaveEvent{saveSlot="latest", saveType="level", prefix=self.currentLevelName .."-"..self.currentLevelDepth})

  --recreate the former level
  events.fireEvent(events.LoadEvent{saveSlot="latest", loadType="level", prefix=levelName .."-"..levelDepth})

  --when provided an entranceId this will determine where to enter in the new level
  local desiredEntranceKey = nil
  local travelX, travelY, travelPlane = nil,nil,nil
  if previousEntranceId then

    local entrances = systems.getEntitiesWithComponent("Entrance")

    --check if we are entering a new levelName
    if self.currentLevelName ~= levelName then
      --determine where the travelers are going
      for key, entranceEntity in pairs(entrances) do
        if entranceEntity.Entrance.levelName == self.currentLevelName then
          travelX = entranceEntity.Physics.x
          travelY = entranceEntity.Physics.y
          travelPlane = levelName .. "-" .. levelDepth
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
          travelPlane = levelName .. "-" .. levelDepth
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


  --save level
  events.fireEvent(events.SaveEvent{saveSlot="latest", saveType="level", prefix=self.currentLevelName .."-"..self.currentLevelDepth})

  --delete entities
  systems.removeAllEntities()

  if string.match(levelEvent.levelName,"overWorld") ~= nil then
    overWorld.build(_getLevelSeed(self, levelEvent), levelEvent)
  elseif string.match(levelEvent.levelName, "tower") or string.match(levelEvent.levelName, "castle") then
      dungeon.build(_getLevelSeed(self, levelEvent), levelEvent)
  elseif string.match(levelEvent.levelName, "forest") then
    forest.build(_getLevelSeed(self, levelEvent), levelEvent)
  elseif string.match(levelEvent.levelName, "cave") then
    cavern.build(_getLevelSeed(self, levelEvent), levelEvent)
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
    if self.currentLevelName ~= levelEvent.levelName then
      for key, entranceEntity in pairs(entrances) do
        if entranceEntity.Entrance.levelName == self.currentLevelName then
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
        if entranceEntity.Entrance.commandKey == desiredEntranceKey then
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

  --place traveler items
  for k, itemEntity in pairs(travelersItems) do
    systems.addEntity(itemEntity)
  end

end

_getLevelSeed = function(self, levelEvent)
  return (string.match(levelEvent.levelName, "%d+") or 0) + levelEvent.levelDepth
end

return LevelSystem
