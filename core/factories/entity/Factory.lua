local lovetoys = require "lib.lovetoys.lovetoys"
require("core.components.components")
local filer = require "data.filer"
Sprite, Faction, Physics, Control, Entrance, Stack, Stock, Ai, Party, Harvest, Recruit, Inventory, Stats,  Boss, Door =
    lovetoys.Component.load({'Sprite', 'Faction', 'Physics', 'Control', 'Entrance', 'Stack', 'Stock', 'Ai', 'Party', 'Harvest', 'Recruit', 'Inventory', 'Stats', 'Boss', 'Door'})

local Factory = {}
filer.requireDirectoryItems(Factory, "Factory", "core/factories/entity/")
return Factory
