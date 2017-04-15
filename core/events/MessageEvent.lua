local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local MessageEvent = class("MessageEvent")

function MessageEvent:initialize(text, type)
    self.text = text
    self.type = type or "visual"
end

return MessageEvent
