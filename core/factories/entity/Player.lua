local lovetoys = require "lib.lovetoys.lovetoys"
local function Player(x, y)
	entity = lovetoys.Entity()
	entity.name = "player"
	entity:add(Physics{x=x, y=y, hp=10, blocks=true})
	entity:add(Sprite{filename="img/sprites/human.png"})
	entity:add(Faction{name="ally"})
	entity:add(Control())
	return entity
end
return Player
