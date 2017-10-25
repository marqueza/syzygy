local lovetoys = require "lib.lovetoys.lovetoys"
local class = require "lib.middleclass"
local systems = require "core.systems.systems"
local components = require "core.components.components"
local events = require "core.events.events"

local UseSystem = class("UseSystem", lovetoys.System)

function UseSystem:initialize()
    lovetoys.System.initialize(self)
end

function UseSystem:onUse(useEvent)
    local subject = systems.getEntityById(useEvent.subjectId)
    local user = systems.getEntityById(useEvent.userId)
    local args = subject.Use.eventArgs
    args[subject.Use.userIdArg] = user.id
    events.fireEvent(events[subject.Use.eventName](args))
end

return UseSystem
