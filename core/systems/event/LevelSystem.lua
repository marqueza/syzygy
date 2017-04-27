local lovetoys = "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local events = require "core.events.events"
local arena = require "core.factories.map.arena"

local LevelSystem = class("LevelSystem", System)

--private methods
local _restoreLevel
local _createLevel
local _storeLevel

function LevelSystem:initialize()
    self.name = "LevelSystem"
    self.seed = 8
    self.currentLevelName = nil
end

function LevelSystem:onNotify(levelEvent)
    --assert(self.currentLevelName ~= levelEvent.levelName)

    --first level
    if self.currentLevelName == nil then
        self.currentLevelName = levelEvent.levelName
        local options = levelEvent.options
        options.player = true
        arena.build(systems.addEntity, self.seed, options)

    --new level replacing old
    else
        --save level
        events.fireEvent(events.SaveEvent{saveSlot="latest", saveType="level", prefix=self.currentLevelName .. "_"})
        --change levelName
        self.currentLevelName = levelEvent.levelName
        --empty entities, except player + party
        assert(game.player)
        systems.removeAllEntitiesExcept(game.player)
        --build the next level
        self.seed= self.seed+1
        arena.build(systems.addEntity, self.seed, levelEvent.options)
        
        --save game
        events.fireEvent(events.SaveEvent{saveSlot="latest", saveType="full", prefix=nil})

    end


end
return LevelSystem
