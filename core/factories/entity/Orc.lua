local lovetoys = require "lib.lovetoys.lovetoys"
local function Orc(x, y)
	entity = lovetoys.Entity()
	entity.name = "orc"
	entity:add(physics{x=x, y=y, hp=10, blocks=true})
	entity:add(sprite{filename="img/sprites/orc.png"})
	entity:add(faction{name="hostile"})
	return entity
end
return Orc
