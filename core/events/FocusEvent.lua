local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local FocusEvent = class("FocusEvent")
FocusEvent:include(Serializable)

function FocusEvent:initialize(args)
    self.x = args.x
    self.y = args.y
    self.dx = args.dx
    self.dy = args.dy
    self.unfocus = args.unfocus or false
end

return FocusEvent
