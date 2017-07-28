local lovetoys = require "lib.lovetoys.lovetoys"
local Entrance  = lovetoys.Component.create("Entrance")
local Serializable = require "data.serializable"
Entrance:include(Serializable)

function Entrance:initialize(args)
    args = args or {}
    self.levelName = args.levelName
    self.commandKey = args.commandKey or ">"
    self.isOpened = args.isOpened
end

return Entrance
