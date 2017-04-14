local lovetoys = require "lib.lovetoys.lovetoys"
local function Golem(x, y)
	entity = lovetoys.Entity()
	entity.name = "golem"
	entity:add(Physics{x=x, y=y, hp=10, blocks=true})
	entity:add(Sprite{filename="img/sprites/golem.png"})
	entity:add(Faction{name="hostile"})
	return entity
end
return Golem
