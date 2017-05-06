local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local Factory = require "core.factories.entity.Factory"
local Systems = require "core.systems.systems"
local SpawnSystem = class("SpawnSystem", System)
SpawnSystem:include(Serializable)

function SpawnSystem:initialize()
    self.name = "SpawnSystem"
end

function SpawnSystem:onNotify(SpawnEvent)
    assert(SpawnEvent.args)
    assert(SpawnEvent.args.name)
    assert(Factory[SpawnEvent.args.name], SpawnEvent.args.name .. " does not exit in Factory directory")
    systems.addEntity(Factory[SpawnEvent.args.name](SpawnEvent.args))
end

return SpawnSystem
