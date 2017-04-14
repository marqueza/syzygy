local lovetoys = require "lib.lovetoys.lovetoys"
local function Wall(x, y)
	entity = lovetoys.Entity()
	entity.name = "wall"
	entity:add(Physics{x=x, y=y, hp=1, blocks=true})
	entity:add(Sprite{filename="img/sprites/wall.png"})
	return entity
end
return Wall
