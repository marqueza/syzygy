local class = require "lib.middleclass"
local Serializable = require "data.serializable"
local CommandKeyEvent = class("CommandKeyEvent")
CommandKeyEvent:include(Serializable)

function CommandKeyEvent:initialize(args)
    self.key = args.key
end

return CommandKeyEvent
