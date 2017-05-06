local lovetoys = require "lib.lovetoys.lovetoys"
local Stock  = lovetoys.Component.create("Stock")
local Serializable = require "data.serializable"
Stock:include(Serializable)

function Stock:initialize(args)
end

return Stock
