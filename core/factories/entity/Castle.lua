local lovetoys = require "lib.lovetoys.lovetoys"
local function Castle(x, y)
	local entity = lovetoys.Entity()
	entity.name = "castle"
	entity:add(Physics{x=x, y=y, hp=10, blocks=false})
	entity:add(Sprite{filename="img/sprites/castle.png"})
	entity:add(Entrance{levelName="1-1", commandKey=">"})
	return entity
end
return Castle
