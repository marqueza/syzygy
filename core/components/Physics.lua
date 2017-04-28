local lovetoys = require "lib.lovetoys.lovetoys"
local Physics  = lovetoys.Component.create("Physics")
local Serializable = require "data.serializable"
Physics:include(Serializable)

function Physics:initialize(args)
    self.x = args.x
    self.y = args.y
    self.blocks = args.blocks
end

return Physics
