local lovetoys = require "lib.lovetoys.lovetoys"
local function Golem(x, y)
	entity = lovetoys.Entity()
	entity.name = "golem"
	entity:add(physics{x=x, y=y, hp=10, blocks=true})
	entity:add(sprite{filename="img/sprites/golem.png"})
	entity:add(faction{name="hostile"})
	return entity
end
return Golem
