local lovetoys = require "lib.lovetoys.lovetoys"
local function Shore(x, y, direction, isCorner)
	entity = lovetoys.Entity()
	entity.name = "shore"
	entity:add(Physics{x=x, y=y, hp=1, blocks=true})
	if isCorner then
		entity:add(Sprite{filename="img/sprites/shore_corner.png", direction=direction})
	else
		entity:add(Sprite{filename="img/sprites/shore.png", direction=direction})
	end
	return entity
end
return Shore
