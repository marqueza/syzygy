local lovetoys = require "lib.lovetoys.lovetoys"
local function Ghost(x, y)
	local entity = lovetoys.Entity()
	entity.name = "Ghost"
	entity:add(Physics{x=x, y=y, hp=10, blocks=true})
	entity:add(Sprite{filename="img/sprites/ghost.png"})
	entity:add(Faction{name="ally"})
	return entity
end
return Ghost
