local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local InteractSelectEvent = class("InteractSelectEvent")
InteractSelectEvent:include(Serializable)

function InteractSelectEvent:initialize(args)
    args = args or {}
    self.selection = args.selection
    self.subjectId = args.subjectId
    self.interactorId = args.interactorId 
end

return InteractSelectEvent