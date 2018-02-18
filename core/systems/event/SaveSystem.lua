local class = require "lib.middleclass"
local lovetoys = require "lib.lovetoys.lovetoys"
local lfs = require "lfs"
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
local _activePrefixes = {}
local _writePlanesToFile

function SaveSystem:initialize()
  self.name = "SaveSystem"
  self.gameId = 2
  self.saveSlot = "latest"
end
function SaveSystem:getSaveDir()
  if game.options.headless then
    return lfs.currentdir() .. "/save/" .. self.gameId .. "/" .. self.saveSlot
  else
    return love.filesystem.getSaveDirectory() .. "/save/" .. self.gameId .. "/".. self.saveSlot
  end
end
function SaveSystem:getLatestDir()
  if game.options.headless then
    return lfs.currentdir() .. "/save/" .. self.gameId .. "/" .. "latest"
  else
    return love.filesystem.getSaveDirectory() .. "/save/" .. self.gameId .. "/".. "latest"
  end
end

function SaveSystem:deleteSaves()
  if game.options.headless then
   for filename in lfs.dir(self:getSaveDir()) do
     os.remove(self:getSaveDir() .. "/" .. filename)
    end
  else
   for key, item in pairs(love.filesystem.getDirectoryItems(self:getSaveDir())) do
     os.remove(self:getSaveDir() .. "/" .. item)
    end
  end
end
function SaveSystem:onSaveNotify(saveEvent)
  if not game.player then return end
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
  if not game.options.headless then
    if not love.filesystem.exists("save/") or not love.filesystem.exists(self:getSaveDir()) then
      love.filesystem.createDirectory("save/")
      love.filesystem.createDirectory("save/" .. self.gameId)
      love.filesystem.createDirectory(self:getSaveDir())
    end
  else 
    if lfs.attributes(self:getSaveDir()) == nil then
      lfs.mkdir("save/")
      lfs.mkdir("save/" .. self.gameId)
      lfs.mkdir(self:getSaveDir())
    end
  end
end

_saveMessageLogs = function (self)
  local f = io.open(self:getSaveDir() .. "/messages.save.txt", 'w')
  f:write(serpent.dump(systems.logSystem.messageLog, {indent = " "}))
  f:close()

  f = io.open(self:getSaveDir() .. "/events.save.txt", 'w')
  f:write(serpent.dump(systems.logSystem.eventLog, {indent = " "}))
  f:close()
  assert(lfs.attributes(self:getSaveDir() .. "/messages.save.txt"), 
         "Did not create "..self:getSaveDir() .. "/messages.save.txt")
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
  local f = io.open(self:getSaveDir() .. "/" .. (prefix or "") .. "_" .. self.gameId ..".save.txt", "w")
  --for index, entity in pairs(systems.getEntitiesWithComponent("Physics")) do
  for index, entity in pairs(systems.engine.entities) do
    if prefix==nil or entity.Physics.plane == prefix then
      f:write("entity ".."{id = \""..entity.id.."\", name = \""..entity.name.."\"}\n")
      for k, v in pairs(entity.components) do
        f:write(v:toString() .. "\n")
      end
    end
  end
  
  if prefix and prefix ~= "" then
    --now save the plane information
    _writePlanesToFile(f, prefix)
  else
    for planeName, planeTable in pairs(systems.planeSystem.planes) do
      --now save the plane information
      _writePlanesToFile(f, planeName)
    end
  end
  
  
  f:write("\n")
  f:close()
end

_writePlanesToFile = function (f, plane) 
  f:write("planes."..plane..".structure " .. serpent.line(systems.planeSystem.planes[plane]["structure"], 
        {comment=false, 
          sparse=true,
          compact=true,
          nohuge=true}))
    f:write("\n")
    f:write("planes."..plane..".visible " .. serpent.line(systems.planeSystem.planes[plane]["visible"], 
        {comment=false, 
          sparse=true,
          compact=true,
          nohuge=true}))
    f:write("\n")
    f:write("planes."..plane..".known " .. serpent.line(systems.planeSystem.planes[plane]["known"], 
        {comment=false, 
          sparse=true,
          compact=true,
          nohuge=true}))
    f:write("\n")
end
_loadEntities = function (self, prefix)
  prefix = prefix or ""
  
  if systems.planeSystem.planes[prefix] then
    return
  end
  
  local fullSave = (prefix == "")
  local tempEnts = {}
  for k, v in pairs(systems.engine.entities) do
    tempEnts[k] = v
  end
  for k, v in pairs(tempEnts) do
    systems.removeEntity(v)
  end

  local e = nil
  local f = io.open(self:getSaveDir() .. "/" .. prefix .. "_" .. self.gameId ..".save.txt", "r")

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
    --creating an plane
    elseif string.find(line, 'planes%.') then
      local planeName, layerName, tableString = string.match(line, "planes%.(.+)%.(.+) (.+)")
      if not pcall(function() ok, layerTable = serpent.load(tableString) end) then
        error("Could not parse " .. planeName .. layerName .. tableString)
      end
      if systems.planeSystem.planes[planeName] == nil then
        systems.planeSystem.planes[planeName] = {}
      end
      systems.planeSystem.planes[planeName][layerName] = layerTable
    else
      --adding a component to an entity
      local ok, t = serpent.load(line)
      if ok and t then
        assert(t.class)
        if components[t.class] == nil then
          t.class = string.gsub(t.class, "class ", "")
        end
        e:add(components[t.class](t))
        if t.class == "Player" then
          game.player = e
        end
      end
    end
  end
  
  systems.addEntity(e)
  local key
  if fullSave then
    key, game.player = next(systems.getEntitiesWithComponent("Control"))
    if game.player == nil then
      key, game.player = next(systems.getEntitiesWithComponent("Adventurer"))
    end
    assert(game.player)
    --systems.levelSystem.currentLevelName, systems.levelSystem.currentLevelDepth = string.match(game.player.Physics.plane, "(%g+)-(%g+)")
  end
  
end
return SaveSystem
