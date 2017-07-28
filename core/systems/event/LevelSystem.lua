local lovetoys = "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local events = require "core.events.events"
local arena = require "core.factories.map.arena"
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

    --first level
    if self.currentLevelName == nil then
        self.currentLevelName = levelEvent.levelName
        arena.build(self.seed, levelEvent)
        events.eventManager:fireEvent(events.LogEvent{
                text="You begin your journey in an unknown land. "
              })
            
            
        events.fireEvent(events.SaveEvent{saveSlot="latest", saveType="full", prefix=nil})


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
              
        --store travelers
        local travelers = {}
        for k, id in pairs(levelEvent.travelerIds) do
          table.insert(travelers, systems.getEntityById(id))
        end
        
        --remove travelers from level
        for k, travelerEntity in pairs(travelers) do
          systems.removeEntity(travelerEntity)
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
            arena.build(self.seed, levelEvent)
        end
        
        --when provided an entranceId this will determine where to enter in the new level
        local desiredEntranceKey = nil
        local travelX, travelY = nil,nil
        if levelEvent.entranceId then
            --determine desired entrance type
            local previousEntranceEntity = systems.getEntityById(levelEvent.entranceId)
            if previousEntranceEntity.Entrance.commandKey == "<" then
              desiredEntranceKey = ">"
            elseif previousEntranceEntity.Entrance.commandKey == ">" then
              desiredEntranceKey = "<"
            end
            
            --now attempt to find this desired entrance
            local entrances = systems.getEntitiesWithComponent("Entrance")
            for key, entranceEntity in pairs(entrances) do
              if entranceEntity.Entrance.commandKey == desiredEntranceKey then
                travelX = entranceEntity.Physics.x
                travelY = entranceEntity.Physics.y
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
        

  end
        --change levelName
        self.currentLevelName = levelEvent.levelName
        --change depth
        self.currentLevelDepth = levelEvent.levelDepth

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
    assert(levelName)
    assert(levelDepth)
    
    --save the travelers
    local travelers = {}
    for k, id in pairs(travelerIds) do
      table.insert(travelers, systems.getEntityById(id))
    end
    
    --remove the travelers
    for k, travelerEntity in pairs(travelers) do
      systems.removeEntity(travelerEntity)
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
      --determine desired entrance type
      local previousEntranceEntity = systems.getEntityById(previousEntranceId)
      if previousEntranceEntity.Entrance.commandKey == "<" then
        desiredEntranceKey = ">"
      elseif previousEntranceEntity.Entrance.commandKey == ">" then
        desiredEntranceKey = "<"
      end

      --now attempt to find this desired entrance
      local entrances = systems.getEntitiesWithComponent("Entrance")
      for key, entranceEntity in pairs(entrances) do
        if entranceEntity.Entrance.commandKey == desiredEntranceKey then
          travelX = entranceEntity.Physics.x
          travelY = entranceEntity.Physics.y
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
end
return LevelSystem
