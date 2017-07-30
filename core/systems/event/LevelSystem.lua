local lovetoys = "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local events = require "core.events.events"
local arena = require "core.factories.map.arena"
local lair = require "core.factories.map.lair"
local cavern = require "core.factories.map.cavern"
local overWorld = require "core.factories.map.overWorld"

local LevelSystem = class("LevelSystem", System)

--private methods
local _restoreLevel
local _createLevel
local _storeLevel

function LevelSystem:initialize()
  self.name = "LevelSystem"
  --self.seed = 8
  self.seed = 9
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
    arena.build(self.seed, levelEvent)
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
  --refocus back on player
  events.fireEvent(events.FocusEvent{dx=0,dy=0, unfocus=false})
  events.fireEvent(events.FocusEvent{dx=0,dy=0, unfocus=true})
  --do a full save
  events.fireEvent(events.SaveEvent{saveSlot="latest", saveType="full", prefix=nil})


end
function LevelSystem:levelVisited(levelName, levelDepth)

  --THIS IS THE NON LOVE WAY. DOES NOT WORK
  --[[local filePath = systems.saveSystem:getSaveDir() .."/".. levelName.."-"..levelDepth.."_"
    ..systems.saveSystem.gameId..".save.txt"
    --local f = io.open(filePath, "r")
    
    if f~=nil then io.close(f) return true else return false end-]]
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
  events.fireEvent(events.SaveEvent{saveSlot="latest", saveType="level", prefix=self.currentLevelName .."-"..self.currentLevelDepth.."_"})

  --recreate the former level
  events.fireEvent(events.LoadEvent{saveSlot="latest", loadType="level", prefix=levelName .."-"..levelDepth.."_"})

  --[[
    --determine the entrances that are opened
    local entrances = systems.getEntitiesWithComponent("Entrance")
    local enterEntranceEntity = nil
    for key, entranceEntity in pairs(entrances) do
      if entranceEntity.Entrance.isOpened then
        assert(enterEntranceEntity == nil, "Multiple enterances have been left opened.")
        entranceEntity.Entrance.isOpened = false
        enterEntranceEntity = entranceEntity
      end
    end
    --]]

  --when provided an entranceId this will determine where to enter in the new level
  local desiredEntranceKey = nil
  local travelX, travelY = nil,nil
  if previousEntranceId then

    local entrances = systems.getEntitiesWithComponent("Entrance")

    --check if we are entering a new levelName
    if self.currentLevelName ~= levelName then
      for key, entranceEntity in pairs(entrances) do
        if entranceEntity.Entrance.levelName == self.currentLevelName then
          travelX = entranceEntity.Physics.x
          travelY = entranceEntity.Physics.y
        end
      end
    end
    --determine desired entrance type
    if not (travelX and travelY) then
      if previousEntranceEntity.Entrance.commandKey == "<" then
        desiredEntranceKey = ">"
      elseif previousEntranceEntity.Entrance.commandKey == ">" then
        desiredEntranceKey = "<"
      end
      for key, entranceEntity in pairs(entrances) do
        if entranceEntity.Entrance.commandKey == desiredEntranceKey then
          travelX = entranceEntity.Physics.x
          travelY = entranceEntity.Physics.y
        end
      end
    end
  end 

  --bring in all the travelers
  for k, travelerEntity in pairs(travelers) do
    if travelX and travelY then 
      travelerEntity.Physics.x = travelX
      travelerEntity.Physics.y = travelY
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
  events.fireEvent(events.SaveEvent{saveSlot="latest", saveType="level", prefix=self.currentLevelName .."-"..self.currentLevelDepth.."_"})

  --delete entities
  systems.removeAllEntities()

  --build the next level
  self.seed=self.seed+1
  if levelEvent.levelName == "overWorld" then
    if self.currentLevelName == "tower" then
      game.player.Physics.x, game.player.Physics.y = 2,2
    elseif self.currentLevelName == "cave" then
      game.player.Physics.x, game.player.Physics.y = 4,4
    end
    overWorld.build(self.seed, levelEvent)
  elseif levelEvent.levelName == "tower" then
    arena.build(self.seed, levelEvent)
  else
    levelEvent.options.color = "brown"
    cavern.build(self.seed, levelEvent)
  end

  --when provided an entranceId this will determine where to enter in the new level
  local desiredEntranceKey = nil
  local travelX, travelY = nil,nil
  if levelEvent.entranceId then
    --determine desired entrance type
    
    if previousEntranceEntity.Entrance.commandKey == "<" then
      desiredEntranceKey = ">"
    elseif previousEntranceEntity.Entrance.commandKey == ">" then
      desiredEntranceKey = "<"
    end

    --now attempt to find this desired entrance
    local entrances = systems.getEntitiesWithComponent("Entrance")
    if self.currentLevelName ~= levelEvent.levelName then
      for key, entranceEntity in pairs(entrances) do
        if entranceEntity.Entrance.levelName == self.currentLevelName then
          travelX = entranceEntity.Physics.x
          travelY = entranceEntity.Physics.y
        end
      end
    end
    if not travelX and travelY then
    for key, entranceEntity in pairs(entrances) do
      if entranceEntity.Entrance.commandKey == desiredEntranceKey then
        travelX = entranceEntity.Physics.x
        travelY = entranceEntity.Physics.y
      end
    end
    end
  end  


  --place travelers
  for k, travelerEntity in pairs(travelers) do
    if travelX and travelY then
      travelerEntity.Physics.x = travelX
      travelerEntity.Physics.y = travelY
    end
    systems.addEntity(travelerEntity)
  end
  
  --place traveler items
  for k, itemEntity in pairs(travelersItems) do
    systems.addEntity(itemEntity)
  end
  
end

return LevelSystem
