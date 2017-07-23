local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local LogEvent = class("LogEvent")

--[[
text - a plain string of what the message composes
type - the categorization of the message. For example: message, debug, etc
--]]
function LogEvent:initialize(args)
    self.text = args.text
    self.type = args.type or "message"
end

return LogEvent
