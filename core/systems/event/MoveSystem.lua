local class = require "lib.middleclass"
local events = require "core.events.events"
local systems = require "core.systems.systems"
local MoveSystem = class("MoveSystem", System)

function MoveSystem:initialize()
    self.name = "Move System"
end

function MoveSystem:onNotify(moveEvent)
    for index, target in pairs(systems.getEntitiesWithComponent("Physics")) do
        local Physics = target:get("Physics")
        if moveEvent.x == Physics.x and moveEvent.y == Physics.y then
          if (Physics.blocks == true) then
            local Faction = target:get("Faction")
            if (target:has("Faction")) then
                if moveEvent.mover.Faction.name ~= target.Faction.name then
                  events.fireEvent(events.LogEvent(moveEvent.mover.name .. " smacks ".. target.name))
                end
            else
                events.fireEvent(events.LogEvent(moveEvent.mover.name .. " bumps " .. target.name))
            end
            events.fireEvent(events.TurnEvent())
            return
          end
        end
    end

    --successful move
    local moverPhysics = moveEvent.mover:get("Physics")
    moverPhysics.x = moveEvent.x
    moverPhysics.y = moveEvent.y
    events.fireEvent(events.TurnEvent())
    return
end

return MoveSystem
