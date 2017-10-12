local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local events = require "core.events.events"
local AutoPressSystem = class("AutoPressSystem", lovetoys.System)

function AutoPressSystem:initialize()
    lovetoys.System.initialize(self)
    self.dtotal = 0
    self.active = false
end

function AutoPressSystem:update(dt)
  if self.active then
  self.dtotal = self.dtotal + dt
   if self.dtotal >= .25 then
      self.dtotal = self.dtotal - .25
     events.fireEvent(events.TurnEvent{})
   end
  end
end
function AutoPressSystem:toggle()
  self.active = not self.active
end

function AutoPressSystem:requires()
    return {}
end

return AutoPressSystem