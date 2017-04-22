local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local SaveEvent = class("SaveEvent")
SaveEvent:include(Serializable)

function SaveEvent:initialize(args)
    args = args or {}
    self.saveSlot = args.saveSlot or "latest"
end

return SaveEvent
