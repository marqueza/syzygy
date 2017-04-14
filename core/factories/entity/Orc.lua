local lovetoys = require "lib.lovetoys.lovetoys"
local function Orc(x, y)
	local entity = lovetoys.Entity()
	entity.name = "orc"
	entity:add(Physics{x=x, y=y, hp=10, blocks=true})
	entity:add(Sprite{filename="img/sprites/orc.png"})
	entity:add(Faction{name="hostile"})
	return entity
end
return Orc
