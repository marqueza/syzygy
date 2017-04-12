local lovetoys = require "lib.lovetoys.lovetoys"
local faction  = lovetoys.Component.create("faction")
local Serializable = require "data.serializable"
faction:include(Serializable)

function faction:initialize(args)
    self.name = args.name
end
