local lovetoys = require "lib.lovetoys.lovetoys"
local function Floor(x, y, color)
	entity = lovetoys.Entity()
	entity.name = "floor"
	entity:add(Physics{x=x, y=y, hp=1, blocks=false})
	entity:add(Sprite{filename="img/sprites/floor.png", color=color})
	return entity
end
return Floor
