local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local LogEvent = class("LogEvent")

function LogEvent:initialize(text, type)
    self.text = text
    self.type = type or "message"
end

return LogEvent
