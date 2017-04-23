local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local KeyPressEvent = class("KeyPressEvent")
KeyPressEvent:include(Serializable)

function KeyPressEvent:initialize(args)
    self.key = args.key
end

return KeyPressEvent
