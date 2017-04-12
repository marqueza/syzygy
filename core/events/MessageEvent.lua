local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local MessageEvent = class("MessageEvent")

function MessageEvent:initialize(text)
    self.text = text
end

return MessageEvent
