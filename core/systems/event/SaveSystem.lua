local class = require "lib.middleclass"
local lovetoys = require "lib.lovetoys.lovetoys"
--local lfs = require "lfs"
local serpent = require "lib.serpent"
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
local _backupSave

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
    _backupSave(self)

    if saveEvent.saveType == "full" then
        _saveMessageLogs(self)
        _saveEntities(self)
        _saveTurn(self)
        self.saveSlot = "latest"
    elseif saveEvent.saveType == "level" then
        _saveEntities(self, saveEvent.prefix)
    end
end

function SaveSystem:onLoadNotify(loadEvent)
  if loadEvent.loadType == nil or loadEvent.loadType == "full" then
    self.saveSlot = loadEvent.saveSlot
    _loadEntities(self)
    _loadMessageLogs(self)
    _loadTurn(self)
    self.saveSlot = "latest"
  elseif loadEvent.loadType == "level" then
    _loadEntities(self, loadEvent.prefix)
  end
end

_backupSave = function (self)
  --[[
    if lfs.attributes("save/") == nil or lfs.attributes(self:getSaveDir()) == nil then
        lfs.mkdir("save/")
        lfs.mkdir("save/" .. self.gameId)
        lfs.mkdir(self:getSaveDir())
        --]]
    if love.filesystem.exists("save/") == nil or love.filesystem.exists(self:getSaveDir()) == nil then
        love.filesystem.createDirectory("save/")
        love.filesystem.createDirectory("save/" .. self.gameId)
        love.filesystem.createDirectory(self:getSaveDir())
    end
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

_saveEntities = function (self, prefix)
    prefix = prefix or ""
    local f = io.open(self:getSaveDir() .. "/" .. prefix .. self.gameId ..".save.txt", "w")
    --for index, entity in pairs(systems.getEntitiesWithComponent("Physics")) do
    for index, entity in pairs(systems.engine.entities) do
        f:write("entity ".."{id = \""..entity.id.."\", name = \""..entity.name.."\"}\n")
        for k, v in pairs(entity.components) do
            f:write(v:toString() .. "\n")
        end
    end
    f:close()
end

_loadEntities = function (self, prefix)
    prefix = prefix or ""
    local tempEnts = {}
    for k, v in pairs(systems.engine.entities) do
        tempEnts[k] = v
    end
    for k, v in pairs(tempEnts) do
      systems.removeEntity(v)
    end

    local e = nil
    local f = io.open(self:getSaveDir() .. "/" .. prefix .. self.gameId ..".save.txt", "r")
    for line in f:lines() do
      
      --creating an entity
        if string.find(line, 'entity') then
            if e ~= nil then
                systems.addEntity(e)
                e = nil
            end
            e = lovetoys.Entity()

            local eLine = string.gsub(line, "entity", "")
            local ok, eLineTable = serpent.load(eLine)
            for k, v in pairs(eLineTable) do
                e[k] = v
            end
            
        --adding a component to an entity
        else
            local ok, t = serpent.load(line)
            if ok then
                assert(t)
                assert(t.class)
                if components[t.class] == nil then
                  t.class = string.gsub(t.class, "class ", "")
                end
                e:add(components[t.class](t))
            end
        end
    end
    systems.addEntity(e)
end
return SaveSystem
