local lovetoys = require "lib.lovetoys.lovetoys"
local function Player(x, y)
	entity = lovetoys.Entity()
	entity.name = "player"
	entity:add(physics{x=x, y=y, hp=10, blocks=true})
	entity:add(sprite{filename="img/sprites/kobold.png"})
	entity:add(faction{name="ally"})
	entity:add(control())
	return entity
end
return Player
