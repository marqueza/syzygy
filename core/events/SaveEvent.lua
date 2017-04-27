local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local SaveEvent = class("SaveEvent")
SaveEvent:include(Serializable)

function SaveEvent:initialize(args)
    args = args or {}
    self.saveSlot = args.saveSlot or "latest"
    self.saveType = args.saveType or "full"
    self.prefix = args.prefix or ""
end

return SaveEvent
