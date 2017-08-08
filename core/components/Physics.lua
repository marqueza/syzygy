local lovetoys = require "lib.lovetoys.lovetoys"
local Physics  = lovetoys.Component.create("Physics")
local Serializable = require "data.serializable"
Physics:include(Serializable)

function Physics:initialize(args)
    self.x = args.x
    self.y = args.y
    self.blocks = args.blocks
    self.hp = args.hp or 1
    self.maxHp = args.maxHp or self.hp
    self.layer = args.layer
    assert(args.plane)
    self.plane = args.plane
end

return Physics
