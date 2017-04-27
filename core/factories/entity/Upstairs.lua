local lovetoys = require "lib.lovetoys.lovetoys"
local function Upstairs(x, y)
	local entity = lovetoys.Entity()
	entity.name = "upstairs"
	entity:add(Physics{x=x, y=y, hp=10, blocks=false})
	entity:add(Sprite{filename="img/sprites/upstairs.png"})
	entity:add(Entrance{levelName="0-0", commandKey="<"})
	return entity
end
return Upstairs
