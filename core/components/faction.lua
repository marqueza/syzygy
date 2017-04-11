local lovetoys = require "lib.lovetoys.lovetoys"
local faction  = lovetoys.Component.create("faction")

function faction:initialize(name)
    self.name = name
end
