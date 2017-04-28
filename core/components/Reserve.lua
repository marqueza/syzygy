local lovetoys = require "lib.lovetoys.lovetoys"
local Reserve  = lovetoys.Component.create("Reserve")
local Serializable = require "data.serializable"
Reserve:include(Serializable)

function Reserve:initialize(args)
end

return Reserve
