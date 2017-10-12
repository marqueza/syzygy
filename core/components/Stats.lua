local lovetoys = require "lib.lovetoys.lovetoys"
local Stats  = lovetoys.Component.create("Stats")
local Serializable = require "data.serializable"
Stats:include(Serializable)

function Stats:initialize(args)
    self.hp = args.hp or 1
    self.maxHp = args.maxHp or self.hp
    self.str = args.str or 1
    self.dex = args.dex or 1
    self.con = args.con or 1
    self.exp = args.exp or 0
end

return Stats
