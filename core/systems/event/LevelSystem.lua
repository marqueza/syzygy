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
    self.currentLevelDepth = 1
end

function LevelSystem:onNotify(levelEvent)
        events.eventManager:fireEvent(events.LogEvent{
                text="ENTERING LEVEL " .. levelEvent.levelName
                })
    if levelEvent.options.depthDelta then
        levelEvent.options.levelDepth = self.currentLevelDepth+levelEvent.options.depthDelta
    end

    --first level
    if self.currentLevelName == nil then
        self.currentLevelName = levelEvent.levelName
        local options = levelEvent.options
        arena.build(systems.addEntity, self.seed, options)

    --entering an existing level
--elseif self:levelVisited(levelEvent.levelName,levelEvent.options.levelDepth) then

--    self:reloadLevel(levelEvent.levelName, levelEvent.options.levelDepth)

    --new level replacing old
    else
        --save level
        events.fireEvent(events.SaveEvent{saveSlot="latest", saveType="level", prefix=self.currentLevelName .."-"..self.currentLevelDepth.."_"})
        --empty entities, except player + party
        assert(game.player)
        systems.removeAllEntitiesExcept(game.player)
        --build the next level
        self.seed=self.seed+1
        if levelEvent.levelName == "overworld" then
            if self.currentLevelName == "tower" then
                game.player.Physics.x, game.player.Physics.y = 2,2
            elseif self.currentLevelName == "cave" then
                game.player.Physics.x, game.player.Physics.y = 4,4
            end
            overWorld.build(systems.addEntity, self.seed, levelEvent.options)
        elseif levelEvent.levelName == "tower" then
            arena.build(systems.addEntity, self.seed, levelEvent.options)
        else
            levelEvent.options.color = "brown"
            arena.build(systems.addEntity, self.seed, levelEvent.options)
        end

        --change levelName
        self.currentLevelName = levelEvent.levelName
        --change depth
        self.currentLevelDepth = levelEvent.options.levelDepth

        --save game
        events.fireEvent(events.SaveEvent{saveSlot="latest", saveType="full", prefix=nil})

    end
end
function LevelSystem:levelVisited(levelName, levelDepth)
    local f = io.open(systems.saveSystem:getSaveDir() .. levelName.."-"..levelDepth.."_"
    ..systems.saveSystem.gameId.."save.txt", "w")
    if f~=nil then io.close(f) return true else return false end
end
function LevelSystem:reloadLevel(levelName, levelDepth)
    systems.saveSystem:loadEntities(levelName.."-"..levelDepth.."_")
end
return LevelSystem
