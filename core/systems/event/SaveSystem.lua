local class = require "lib.middleclass"
local lovetoys = require "lib.lovetoys.lovetoys"
local lfs = require "lfs"
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
    self.gameId = 2
    self.saveSlot = "latest"
end
function SaveSystem:getSaveDir()
    return "save/" .. self.gameId .. "/".. self.saveSlot
end
function SaveSystem:getLatestDir()
    return "save/" .. self.gameId .. "/".. "latest"
end

function SaveSystem:onSaveNotify(saveEvent)
    self.saveSlot = saveEvent.saveSlot

    if lfs.attributes("save/") == nil or lfs.attributes(self:getSaveDir()) == nil then
      lfs.mkdir("save/")
      lfs.mkdir("save/" .. self.gameId)
      lfs.mkdir(self:getSaveDir())
    else
        os.execute("rm -r save/"..self.gameId .. "/backup")
        os.execute("cp -r save/"..self.gameId.."/latest".." ".."save/"..self.gameId .. "/backup")
    end
    _saveMessageLogs(self)
    _saveEntities(self)
    _saveTurn(self)
    self.saveSlot = "latest"
end

function SaveSystem:onLoadNotify(loadEvent)
    self.saveSlot = loadEvent.saveSlot
    _loadEntities(self)
    _loadMessageLogs(self)
    _loadTurn(self)
    self.saveSlot = "latest"
end

_saveMessageLogs = function (self)
    local f = io.open(self:getSaveDir() .. "/messages.save.txt", 'w')
    f:write(serpent.dump(systems.logSystem.messageLog, {indent = " "}))
    f:close()

    f = io.open(self:getSaveDir() .. "/events.save.txt", 'w')
    f:write(serpent.dump(systems.logSystem.eventLog, {indent = " "}))
    f:close()
end

_loadMessageLogs = function (self)
    local f = io.open(self:getSaveDir() .. "/messages.save.txt", 'r')
    local logString = f:read("*all")
    local ok, logTable = serpent.load(logString)
    systems.logSystem.messageLog = logTable
    f:close()

    f = io.open(self:getSaveDir() .. "/events.save.txt", 'r')
    local logString = f:read("*all")
    local ok, logTable = serpent.load(logString)
    systems.logSystem.eventLog = logTable
    f:close()
end

_saveTurn = function (self)
    local f = io.open(self:getSaveDir() .. "/turn.save.txt", 'w')
    f:write(systems.turnSystem:toString())
    f:close()
end

_loadTurn = function (self)
    local f = io.open(self:getSaveDir() .. "/turn.save.txt", 'r')
    local turnString = f:read()
    local ok, turnTable = serpent.load(turnString)
    systems.turnSystem:restore(turnTable)
    f:close()
end

_saveEntities = function (self)
    local f = io.open(self:getSaveDir() .. "/" .. self.gameId ..".save.txt", "w")
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
    local f = io.open(self:getSaveDir() .. "/" .. self.gameId ..".save.txt", "r")
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
