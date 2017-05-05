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
    --allow spawn only on empty floors
    --for now just spawn at 2,2
    systems.addEntity(Factory.Ghost(2, 2))
end

return SpawnSystem
