local lovetoys = require "lib.lovetoys.lovetoys"
local Boss  = lovetoys.Component.create("Boss")
local Serializable = require "data.serializable"
Boss:include(Serializable)

function Boss:initialize(args)
end

return Boss
