local lovetoys = require "lib.lovetoys.lovetoys"
local Skills  = lovetoys.Component.create("Skills")
local Serializable = require "data.serializable"
Skills:include(Serializable)

function Skills:initialize(args)
    self.strike = args.strike or 1
    self.dodge = args.dodge or 1
end

return Skills