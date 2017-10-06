local class = require "lib.middleclass"
--local Serializable = require "data.serializable"
local events = require "core.events.events"
local systems = require "core.systems.systems"
local TargetSystem = class("TargetSystem", System)

function TargetSystem:initialize()
    self.name = "TargetSystem"
    self.target = nil
    self.focus = nil
    self.focusX = 0
    self.focusY = 0
end

function TargetSystem:refreshFocus()
  events.fireEvent(events.FocusEvent{dx=0, dy=0})
  events.fireEvent(events.FocusEvent{unfocus=true})
end

function TargetSystem:onLoadNotify(loadEvent)
  --target on player
  self.target = game.player
end

function TargetSystem:onFocusNotify(focusEvent)
    if focusEvent.unfocus then
        self.focus = nil
        return
    end

    if self.focus then
        if focusEvent.dx and focusEvent.dy then
            self.focusX = self.focusX + focusEvent.dx
            self.focusY = self.focusY + focusEvent.dy
            focusEvent.x = self.focus.Physics.x + focusEvent.dx
            focusEvent.y = self.focus.Physics.y + focusEvent.dy
        end
    else
        if focusEvent.dx and focusEvent.dy then
            --local key
            --key, game.player = next(systems.getEntitiesWithComponent("Control"))
            self.focusX = game.player.Physics.x + focusEvent.dx
            self.focusY = game.player.Physics.y + focusEvent.dy
            focusEvent.x = game.player.Physics.x + focusEvent.dx
            focusEvent.y = game.player.Physics.y + focusEvent.dy
        end
    end

    if systems.planeSystem:isVisibleSpace(self.focusX, self.focusY, game.player.Physics.plane) then
      local eList = systems.planeSystem:getEntityList(self.focusX, self.focusY, "creature", game.player.Physics.plane)
      local focus = nil
      if eList then 
        for key, entity in pairs(eList) do
          if entity.Control then
            focus = entity
          end
        end
      end
      if focus == nil then
        focus = systems.planeSystem:getTopEntity(self.focusX, self.focusY, "creature", game.player.Physics.plane)
      end
      if focus then
        self.focus = focus
      end
    end
end

return TargetSystem
