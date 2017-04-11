local lovetoys = require "lib.lovetoys.lovetoys"
local function Wall(x, y)
	entity = lovetoys.Entity()
	entity.name = "wall"
	entity:add(physics{x=x, y=y, hp=1, blocks=true})
	entity:add(sprite("img/sprites/wall.png"))
	return entity
end
return Wall
