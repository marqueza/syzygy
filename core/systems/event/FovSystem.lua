local class = require "lib.middleclass"
local rot = require "lib.rotLove.src.rot"
local FovSystem = class("FovSystem", System)
local events = require "core.events.events"
local systems = require "core.systems.systems"



function FovSystem:initialize()
  self.name = "FovSystem"
  self.radius = 6
end

--returning true: light passes through
--returning false: sight is blocked
function FovSystem.getTranslucentFunction(plane)
return function (fov, x, y)
  local entityList = systems.planeSystem:getEntityList(x, y, "backdrop", plane)
  if not systems.planeSystem:isFloorSpace(x, y, plane) then
    return false
  end
  if entityList then
    for k, entity in pairs(entityList) do
      if entity.Physics.blocks and not entity.Physics.allowsFov then
        return false
      end
    end
  end
  return true
end
end

function FovSystem.getMarkFunction(plane)
 return function (x, y, r, v)
  if not x or not y then return end
  local entityList = systems.planeSystem:getEntityList(x, y, nil, plane)
  for k, entity in pairs(entityList) do
    entity.Sprite.isVisible = true
  end
  systems.planeSystem:setVisibleSpace(x, y, plane)
  systems.planeSystem:setKnownSpace(x, y, plane)
  end
end

function FovSystem:onNotify(TurnEvent)
  if not game.player then
    return
  end
    local leaders = systems.getEntitiesWithComponent("Party")
    systems.planeSystem:clearVisible(x, y, game.player.Physics.plane)
    for id, leader in pairs(leaders) do
      self.fov=rot.FOV.Precise:new(FovSystem.getTranslucentFunction(leader.Physics.plane))
      self.fov:compute(leader.Physics.x, leader.Physics.y, self.radius, self.getMarkFunction(leader.Physics.plane))
    end
end

return FovSystem
