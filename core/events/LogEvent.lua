local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local LogEvent = class("LogEvent")

function LogEvent:initialize(args)
    self.text = args.text
    self.type = args.type or "message"
end

return LogEvent
