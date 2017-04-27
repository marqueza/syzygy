local lovetoys = require "lib.lovetoys.lovetoys"
local function Grass(x, y)
	entity = lovetoys.Entity()
	entity.name = "grass"
	entity:add(Physics{x=x, y=y, hp=1, blocks=false})
	entity:add(Sprite{filename="img/sprites/grass.png"})
	return entity
end
return Grass
