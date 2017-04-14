local class = require "lib.middleclass"
local lovetoys = require "lib.lovetoys.lovetoys"
local serpent = require "serpent"
local events = require "core.events.events"
local components = require "core.components.components"
local systems = require "core.systems.systems"
local SaveSystem = class("SaveSystem", System)

--private methods
local _saveMessageLog
local _saveTurn
local _saveEntities
local _loadMessageLog
local _loadTurn
local _loadEntities

function SaveSystem:initialize()
    self.name = "SaveSystem"
end

function SaveSystem:onSaveNotify(SaveEvent)
    _saveMessageLog()
    _saveEntities()
    _saveTurn()
end

function SaveSystem:onLoadNotify(LoadEvent)
    _loadEntities()
    _loadMessageLog()
    _loadTurn()
end

_saveMessageLog = function (self)
    f = io.open("messages.save.txt", 'w')
    f:write(serpent.dump(systems.messageSystem.log))
    f:close()
end

_loadMessageLog = function (self)
    f = io.open("messages.save.txt", 'r')
    local logString = f:read()
    local ok, logTable = serpent.load(logString)
    systems.messageSystem.log = logTable
    f:close()
end

_saveTurn = function (self)
    f = io.open("turn.save.txt", 'w')
    f:write(systems.turnSystem:toString())
    f:close()
end

_loadTurn = function (self)
    f = io.open("turn.save.txt", 'r')
    local turnString = f:read()
    local ok, turnTable = serpent.load(turnString)
    systems.turnSystem:restore(turnTable)
    f:close()
end

_saveEntities = function (self)
    f = io.open("1.save.txt", "w")
    for index, entity in pairs(systems.getEntitiesWithComponent("Physics")) do
        f:write("entity ".."{id = "..entity.id..", name = \""..entity.name.."\"}\n")
        for k, v in pairs(entity.components) do
            f:write(v:toString() .. "\n")
        end
    end
    f:close()
end

_loadEntities = function (self)
    local tempEnts = {}
    for k, v in pairs(systems.engine.entities) do
        tempEnts[k] = v
    end
    for k, v in pairs(tempEnts) do
      systems.engine:removeEntity(v)
    end

    local e = nil
    f = io.open("1.save.txt", "r")
    for line in f:lines() do
        if string.find(line, 'entity') then
            if e ~= nil then
                systems.engine:addEntity(e)
                e = nil
            end
            e = lovetoys.Entity()

            local eLine = string.gsub(line, "entity", "")
            local ok, eLineTable = serpent.load(eLine)
            for k, v in pairs(eLineTable) do
                e[k] = v
            end
        else
            local ok, t = serpent.load(line)
            if ok then
                e:add(components[t.class](t))
            end
        end
    end
    systems.engine:addEntity(e)
end
return SaveSystem
