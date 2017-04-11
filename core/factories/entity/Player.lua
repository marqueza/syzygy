local lovetoys = require "lib.lovetoys.lovetoys"
local function Player(x, y)
	entity = lovetoys.Entity()
	entity.name = "player"
	entity:add(
		physics{
			x=x,
			y=y,
			hp=1,
			blocks=true
		}
	)
	entity:add(faction("ally"))
	entity:add(sprite("img/sprites/kobold.png"))
	entity:add(control())
	return entity
end
return Player
