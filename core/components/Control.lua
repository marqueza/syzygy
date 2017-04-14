local lovetoys = require "lib.lovetoys.lovetoys"
local Control = lovetoys.Component.create("Control")
local Serializable = require "data.serializable"
Control:include(Serializable)

function Control:initialize()
end

return Control
