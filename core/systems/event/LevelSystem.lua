local lovetoys = "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local arena = require "core.factories.map.arena"
local LevelSystem = class("LevelSystem", System)

--private methods
local _restoreLevel
local _createLevel
local _storeLevel

function LevelSystem:initialize()
    self.name = "LevelSystem"
    self.seed = 8
end

function LevelSystem:onNotify(levelEvent)
    arena.build(systems.addEntity, self.seed, levelEvent.options)
end
return LevelSystem
