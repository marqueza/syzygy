local lovetoys = require "lib.lovetoys.lovetoys"
require("core.components.components")
local filer = require "data.filer"

Sprite, Faction, Physics, Control, Entrance, Stack, Stock, Ai =
    lovetoys.Component.load({'Sprite', 'Faction', 'Physics', 'Control', 'Entrance', 'Stack', 'Stock', 'Ai'})

local Factory = {}
filer.requireDirectoryItems(Factory, "Factory", "core/factories/entity/")
return Factory
