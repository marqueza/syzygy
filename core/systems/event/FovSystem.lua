local class = require "lib.middleclass"
local rot = require "lib.rotLove.src.rot"
local FovSystem = class("FovSystem", System)
local events = require "core.events.events"
local systems = require "core.systems.systems"



function FovSystem:initialize()
    self.name = "FovSystem"
    self.fov=rot.FOV.Precise:new(FovSystem.isTranslucent)
end

--returning true: light passes through
--returning false: sight is blocked
function FovSystem.isTranslucent(fov, x, y)
    local entityList = systems.planeSystem:getEntityList(x, y, "backdrop")
    for k, entity in pairs(entityList) do
        if entity.Physics.blocks then
            return false
        end
    end
    return true
end

function FovSystem.markFov(x, y, r, v)
    if not x or not y then return end
    local entityList = systems.planeSystem:getEntityList(x, y)
    for k, entity in pairs(entityList) do
        entity.Sprite.isVisible = true
    end
end

function FovSystem:onNotify(TurnEvent)
    self.fov:compute(game.player.Physics.x, game.player.Physics.y, 10, self.markFov)
end

return FovSystem
