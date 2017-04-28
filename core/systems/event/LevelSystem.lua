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
    self.seed = 8
    self.currentLevelName = nil
end

function LevelSystem:onNotify(levelEvent)
        events.eventManager:fireEvent(events.LogEvent{
                text="ENTERING LEVEL " .. levelEvent.levelName
                })

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
        --empty entities, except player + party
        assert(game.player)
        systems.removeAllEntitiesExcept(game.player)
        --build the next level
        self.seed= self.seed+1
        if levelEvent.levelName == "0-0" then

            if self.currentLevelName == "1-1" then
                game.player.Physics.x, game.player.Physics.y = 2,2
            else
                game.player.Physics.x, game.player.Physics.y = 4,4
            end

            overWorld.build(systems.addEntity, self.seed, levelEvent.options)
        elseif levelEvent.levelName == "1-1" then
            arena.build(systems.addEntity, self.seed, levelEvent.options)
        else
            levelEvent.options.color = "brown"
            arena.build(systems.addEntity, self.seed, levelEvent.options)
        end

        --change levelName
        self.currentLevelName = levelEvent.levelName


        --save game
        events.fireEvent(events.SaveEvent{saveSlot="latest", saveType="full", prefix=nil})

    end


end
return LevelSystem
