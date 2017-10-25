local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local UseEvent = class("UseEvent")
UseEvent:include(Serializable)

function UseEvent:initialize(args)
    self.subjectId = args.subjectId
    self.userId = args.userId
end

return UseEvent
