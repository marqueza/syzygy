local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local InteractEnterEvent = class("InteractEnterEvent")
InteractEnterEvent:include(Serializable)

function InteractEnterEvent:initialize(args)
    args = args or {}
    self.subjectId = args.subjectId
    self.interactorId = args.interactorId 
end

return InteractEnterEvent
