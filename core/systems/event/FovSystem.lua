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
  local planeName = game.player.Physics.plane
      local entityList = systems.planeSystem:getEntityList(x, y, "backdrop", planeName)
      if not systems.planeSystem:isFloorSpace(x, y, planeName) then
        return false
      end
      if entityList then
        for k, entity in pairs(entityList) do
            if entity.Physics.blocks then
                return false
            end
        end
      end
    return true
end

function FovSystem.markFov(x, y, r, v)
    if not x or not y then return end
    for planeName, planeTable in pairs(systems.planeSystem.planes) do
      local entityList = systems.planeSystem:getEntityList(x, y, nil, planeName)
      for k, entity in pairs(entityList) do
          entity.Sprite.isVisible = true
      end
      systems.planeSystem:setVisibleSpace(x, y, planeName)
      systems.planeSystem:setKnownSpace(x, y, planeName)
    end
end

function FovSystem:onNotify(TurnEvent)
    systems.planeSystem:clearVisible(x, y, game.player.Physics.plane)
    self.fov:compute(game.player.Physics.x, game.player.Physics.y, 6, self.markFov)
end

return FovSystem
