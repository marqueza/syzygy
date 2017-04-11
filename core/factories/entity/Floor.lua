local lovetoys = require "lib.lovetoys.lovetoys"
local function Floor(x, y)
	entity = lovetoys.Entity()
	entity.name = "floor"
	entity:add(physics{x=x, y=y, hp=1, blocks=false})
	entity:add(sprite("img/sprites/floor.png"))
	return entity
end
return Floor
